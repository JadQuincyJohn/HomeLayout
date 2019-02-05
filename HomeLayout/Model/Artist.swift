//
//  Artist.swift
//  DeezerExercise
//
//  Created by Zedenem on 02/09/2018.
//  Copyright © 2018 Zedenem. All rights reserved.
//

import Foundation

struct Artist: Codable, Equatable {
  let id: Int
  let name: String
  let link: URL
  let picture_medium: URL
}

func ==(lhs: Artist, rhs: Artist) -> Bool {
  return lhs.id == rhs.id
    && lhs.name == rhs.name
    && lhs.link == rhs.link
    && lhs.picture_medium == rhs.picture_medium
}

