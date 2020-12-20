//
//  Board.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import Foundation
import RealmSwift

final class Boards: Object, Codable {
  
  // MARK: - Property
  
  @objc dynamic var id: Int = 0
  var myBoards = List<Board>()
  var invitedBoards = List<Board>()
  
  override class func primaryKey() -> String? {
    return "id"
  }
  
  
  // MARK: - Initializer
  
  required convenience init(from decoder: Decoder) throws {
    self.init()
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let decodedMyBoards = try container.decodeIfPresent([Board].self, forKey: .myBoards) ?? []
    let decodedInvitedBoards = try container.decodeIfPresent([Board].self, forKey: .invitedBoards) ?? []
    
    myBoards.append(objectsIn: decodedMyBoards)
    invitedBoards.append(objectsIn: decodedInvitedBoards)
  }
  
  
  // MARK: - Method
  
  func fetchMyBoard() -> [Board] {
    return Array(myBoards)
  }
  
  func fetchInvitedBoard() -> [Board] {
    return Array(invitedBoards)
  }
}

final class Board: Object, Codable {
  
  // MARK: - Property
  
  @objc dynamic var id: Int = UUID().hashValue
  @objc dynamic var title: String = ""
  @objc dynamic var color: String = ""
  
  override class func primaryKey() -> String? {
    return "id"
  }
}


