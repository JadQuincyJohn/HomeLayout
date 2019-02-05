//
//  Album.swift
//  DeezerExercise
//
//  Created by Zedenem on 02/09/2018.
//  Copyright © 2018 Zedenem. All rights reserved.
//

import Foundation

struct Album: Codable, Equatable {
  let id: Int
  let title: String
  let cover_medium: URL
}

func ==(lhs: Album, rhs: Album) -> Bool {
  return lhs.id == rhs.id
    && lhs.title == rhs.title
    && lhs.cover_medium == rhs.cover_medium
}


