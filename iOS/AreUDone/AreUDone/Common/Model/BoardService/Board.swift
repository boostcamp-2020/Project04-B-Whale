//
//  Board.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import Foundation

struct Boards: Codable {
  let myBoards, invitedBoards: [Board]
}

struct Board: Codable {
  let id: Int
  let title: String
  let color: String
}

extension Board: Hashable {
  static func == (lhs: Board, rhs: Board) -> Bool {
    return lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
