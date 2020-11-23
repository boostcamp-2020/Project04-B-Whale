//
//  Card.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/23.
//

import Foundation

struct Cards: Codable {
    let cards: [Card]
}

struct Card: Codable {
    let id: Int
    let title, dueDate: String
    let commentCount: Int
}

extension Card: Hashable {
  
  static func == (lhs: Card, rhs: Card) -> Bool {
    return lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
