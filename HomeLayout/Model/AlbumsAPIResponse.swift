//
//  AlbumsAPIResponse.swift
//  DeezerExercise
//
//  Created by Zedenem on 04/09/2018.
//  Copyright © 2018 Zedenem. All rights reserved.
//

import Foundation

//TODO: Refactoring with DeezerAPIResponse or ListAPIResponse required
struct AlbumsAPIResponse: Codable, Equatable {
  var albums: [Album]
  let totalAlbums: Int
  let previousAlbumsURL: URL?
  let nextAlbumsURL: URL?
  let tracksAPIResponse: TracksAPIResponse? = nil

  enum CodingKeys : String, CodingKey {
    case albums = "data"
    case totalAlbums = "total"
    case previousAlbumsURL = "prev"
    case nextAlbumsURL = "next"
  }
}

func ==(lhs: AlbumsAPIResponse, rhs: AlbumsAPIResponse) -> Bool {
  return lhs.albums == rhs.albums
    && lhs.totalAlbums == rhs.totalAlbums
    && lhs.previousAlbumsURL == rhs.previousAlbumsURL
    && lhs.nextAlbumsURL == rhs.nextAlbumsURL
    && lhs.tracksAPIResponse == rhs.tracksAPIResponse
}

