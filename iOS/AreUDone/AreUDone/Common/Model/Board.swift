//
//  Board.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import Foundation
import RealmSwift

class Boards: Object, Codable {
  @objc dynamic var id: Int = 0
  var myBoards = List<Board>()
  var invitedBoards = List<Board>()
  
  override class func primaryKey() -> String? {
    return "id"
  }
  
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
  @objc dynamic var id: Int = UUID().hashValue
  @objc dynamic var title: String = ""
  @objc dynamic var color: String = ""
  
  override class func primaryKey() -> String? {
    return "id"
  }
}


