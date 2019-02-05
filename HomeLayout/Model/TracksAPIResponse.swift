//
//  TracksAPIResponse.swift
//  DeezerExercise
//
//  Created by Zedenem on 02/09/2018.
//  Copyright © 2018 Zedenem. All rights reserved.
//

import Foundation

struct TracksAPIResponse: Codable, Equatable {
  var tracks: [Track]
  let totalTracks: Int
  var previousTracksURL: URL?
  var nextTracksURL: URL?

  enum CodingKeys : String, CodingKey {
    case tracks = "data"
    case totalTracks = "total"
    case previousTracksURL = "prev"
    case nextTracksURL = "next"
  }
}

func ==(lhs: TracksAPIResponse, rhs: TracksAPIResponse) -> Bool {
  return lhs.tracks == rhs.tracks
    && lhs.totalTracks == rhs.totalTracks
    && lhs.previousTracksURL == rhs.previousTracksURL
    && lhs.nextTracksURL == rhs.nextTracksURL
}
