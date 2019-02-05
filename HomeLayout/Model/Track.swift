//
//  Track.swift
//  DeezerExercise
//
//  Created by Zedenem on 02/09/2018.
//  Copyright © 2018 Zedenem. All rights reserved.
//

import Foundation

struct Track: Codable, Equatable {
  let id: Int
  let readable: Bool
  let title: String
  let title_short: String
  let title_version: String
  let link: URL
  let duration: Int
  let rank: Int
  let explicit_lyrics: Bool
  let preview: URL
  let previewDuration: Double = 30
}

func ==(lhs: Track, rhs: Track) -> Bool {
  return lhs.id == rhs.id
    && lhs.readable == rhs.readable
    && lhs.title == rhs.title
    && lhs.title_short == rhs.title_short
    && lhs.title_version == rhs.title_version
    && lhs.link == rhs.link
    && lhs.duration == rhs.duration
    && lhs.rank == rhs.rank
    && lhs.explicit_lyrics == rhs.explicit_lyrics
    && lhs.preview == rhs.preview
}

