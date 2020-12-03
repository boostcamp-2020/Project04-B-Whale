//
//  List.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import Foundation
import MobileCoreServices
//
//struct Lists: Codable {
//  let lists: [List]
//}

class List: Codable {
  let id: Int
  let title: String
  let position: Int
  var cards: [Card]
  
  init(id: Int, title: String, position: Int, cards: [Card]) {
    self.id = id
    self.title = title
    self.position = position
    self.cards = cards
  }
}

extension List: Hashable {
  
  static func == (lhs: List, rhs: List) -> Bool {
    return lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
