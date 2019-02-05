//
//  ArtistsAPIResponse
//  DeezerExercise
//
//  Created by Zedenem on 03/09/2018.
//  Copyright © 2018 Zedenem. All rights reserved.
//

import Foundation

struct ArtistsAPIResponse: Codable, Equatable {
  var artists: [Artist]
  let totalArtists: Int
  var previousArtistsURL: URL?
  var nextArtistsURL: URL?

  enum CodingKeys : String, CodingKey {
    case artists = "data"
    case totalArtists = "total"
    case previousArtistsURL = "prev"
    case nextArtistsURL = "next"
  }
}

func ==(lhs: ArtistsAPIResponse, rhs: ArtistsAPIResponse) -> Bool {
  return lhs.artists == rhs.artists
    && lhs.totalArtists == rhs.totalArtists
    && lhs.previousArtistsURL == rhs.previousArtistsURL
    && lhs.nextArtistsURL == rhs.nextArtistsURL
}

