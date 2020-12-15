//
//  Board.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import Foundation
import RealmSwift

class Boards: Object, Codable {
  var myBoards = List<Board>()
  var invitedBoards = List<Board>()
  
  required convenience init(from decoder: Decoder) throws {
    self.init()
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let decodedMyBoards =
      try container.decodeIfPresent([Board].self, forKey: .myBoards) ?? []
    myBoards.append(objectsIn: decodedMyBoards)
    
    let decodedInvitedBoards =
      try container.decodeIfPresent([Board].self, forKey: .invitedBoards) ?? []
    invitedBoards.append(objectsIn: decodedInvitedBoards)
  }
  
  func fetchMyBoard() -> [Board] {
    return Array(myBoards)
  }
  
  func fetchInvitedBoard() -> [Board] {
    return Array(invitedBoards)
  }
}

class Board: Object, Codable {
  @objc dynamic var id: Int = 0
  @objc dynamic var title: String = ""
  @objc dynamic var color: String = ""
}


