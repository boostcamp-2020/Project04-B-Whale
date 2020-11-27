//
//  List.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import Foundation

struct Lists: Codable {
  let lists: [List]
}

struct List: Codable {
  let id: Int
  let title: String
  let position: Int
  var cards: [Card]
}

extension List: Hashable {
  
  static func == (lhs: List, rhs: List) -> Bool {
    return lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
