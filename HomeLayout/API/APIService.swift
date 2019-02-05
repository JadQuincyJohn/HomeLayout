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
    typealias AlbumsAPICompletion = (_ results: AlbumsAPIResponse?, _ error: APIError?) -> Void
    
    let defaultSession: URLSessionProtocol
    
    init() {
        defaultSession = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    init(session: URLSessionProtocol) {
        defaultSession = session
    }
    
    // MARK: - Get Albums from artist
    func getAlbums(with artistId: Int, limit: Int = 1, completion: @escaping AlbumsAPICompletion = {_, _ in}) {
        
        print("getAlbums with artist id: \(artistId)")
        
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
}

// MARK: - Generic Data task method
extension APIService {
    func performDataTask(with url: URL, completion: @escaping APICompletion = {_, _ in}) {

        let task = defaultSession.dataTask(with: url) { data, response, error in
            
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
        task.resume()
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
