//
//  APIService.swift
//  DeezerExercise
//
//  Created by Zedenem on 31/08/2018.
//  Copyright © 2018 Zedenem. All rights reserved.
//

import Foundation

// MARK: Mocking protocols (For Unit Tests)
protocol URLSessionProtocol {
    var configuration: URLSessionConfiguration { get }
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}
extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}

protocol URLSessionDataTaskProtocol {
    func cancel()
    func resume()
}
extension URLSessionDataTask: URLSessionDataTaskProtocol {}

// MARK: -
class APIService {
    typealias JSONDictionary = [String: Any]
    //TODO: Add a proper error type here
    typealias APICompletion = (_ data: Data?, _ error: APIError?) -> Void
    typealias ArtistsAPICompletion = (_ results: ArtistsAPIResponse?, _ error: APIError?) -> Void
    typealias AlbumsAPICompletion = (_ results: AlbumsAPIResponse?, _ error: APIError?) -> Void
    typealias TracksAPICompletion = (_ results: TracksAPIResponse?, _ error: APIError?) -> Void
    
    let defaultSession: URLSessionProtocol
    var defaultDataTask: URLSessionDataTaskProtocol?
    
    init() {
        defaultSession = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    init(session: URLSessionProtocol) {
        defaultSession = session
    }
    
    // MARK: - Search Artists
    func searchArtists(like searchTerm: String, completion: @escaping ArtistsAPICompletion = {_, _ in}) {
        guard var urlComponents = URLComponents(string: "https://api.deezer.com/search/artist") else {
            completion(nil, APIError.malformedURLError)
            return
        }
        urlComponents.query = "q=\(searchTerm)"
        guard let url = urlComponents.url else {
            completion(nil, APIError.malformedURLError)
            return
        }
        
        performDataTask(with: url) { data, error in
            if let data = data {
                let (artistsAPIResponse, decodingError) = self.decodeAPIResponse(data, responseType: ArtistsAPIResponse.self)
                completion(artistsAPIResponse, decodingError)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func getNextArtists(artistsAPIResponse: ArtistsAPIResponse, completion: @escaping ArtistsAPICompletion = {_, _ in}) {
        guard let nextArtistsURL = artistsAPIResponse.nextArtistsURL else {
            completion(nil, APIError.noAdditionalResultsError)
            return
        }
        
        performDataTask(with: nextArtistsURL) { data, error in
            if let data = data {
                let (newArtistsAPIResponse, decodingError) = self.decodeAPIResponse(data, responseType: ArtistsAPIResponse.self)
                completion(newArtistsAPIResponse, decodingError)
            } else {
                completion(nil, error)
            }
        }
    }
    
    // MARK: - Get Albums from artist
    func getAlbums(with artistId: Int, limit: Int = 1, completion: @escaping AlbumsAPICompletion = {_, _ in}) {
        guard var urlComponents = URLComponents(string: "https://api.deezer.com/artist/\(artistId)/albums") else {
            completion(nil, APIError.malformedURLError)
            return
        }
        urlComponents.query = "limit=\(limit)"
        guard let url = urlComponents.url else {
            completion(nil, APIError.malformedURLError)
            return
        }
        
        performDataTask(with: url) { data, error in
            if let data = data {
                let (albumsAPIResponse, decodingError) = self.decodeAPIResponse(data, responseType: AlbumsAPIResponse.self)
                if albumsAPIResponse != nil && albumsAPIResponse!.totalAlbums > 0 {
                    completion(albumsAPIResponse, decodingError)
                } else {
                    completion(nil, APIError.noResultsError)
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    // MARK: - Get Tracks from album
    func getTracks(fromAlbum album: Album, completion: @escaping TracksAPICompletion = {_, _ in}) {
        guard let url = URL(string: "https://api.deezer.com/album/\(album.id)/tracks") else {
            completion(nil, APIError.malformedURLError)
            return
        }
        
        performDataTask(with: url) { data, error in
            if let data = data {
                let (tracksAPIResponse, decodingError) = self.decodeAPIResponse(data, responseType: TracksAPIResponse.self)
                completion(tracksAPIResponse, decodingError)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func getNextTracks(fromTracksAPIResponse tracksAPIResponse: TracksAPIResponse, completion: @escaping TracksAPICompletion = {_, _ in}) {
        guard let nextTracksURL = tracksAPIResponse.nextTracksURL else {
            completion(nil, APIError.noAdditionalResultsError)
            return
        }
        
        performDataTask(with: nextTracksURL) { data, error in
            if let data = data {
                let (newTracksAPIResponse, decodingError) = self.decodeAPIResponse(data, responseType: TracksAPIResponse.self)
                completion(newTracksAPIResponse, decodingError)
            } else {
                completion(nil, error)
            }
        }
    }
}

// MARK: - Generic Data task method
extension APIService {
    func performDataTask(with url: URL, completion: @escaping APICompletion = {_, _ in}) {
        defaultDataTask?.cancel()
        
        defaultDataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer { self.defaultDataTask = nil }
            
            let statusCode: Int
            if let response = response as? HTTPURLResponse {
                statusCode = response.statusCode
            } else {
                statusCode = -1
            }
            
            if let error = error {
                completion(nil, APIError.serverError(message: error.localizedDescription, statusCode: statusCode))
            } else if let data = data {
                completion(data, nil)
            }
        }
        defaultDataTask?.resume()
    }
}

// MARK: - Generic Decoder method
extension APIService {
    func decodeAPIResponse<T: Codable>(_ data: Data, responseType: T.Type) -> (response: T?, error: APIError?) {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(T.self, from: data)
            return (response, nil)
        } catch {
            //TODO: Better error handling from the thrown error
            return (nil, APIError.decodingError(message: error.localizedDescription))
        }
    }
}
