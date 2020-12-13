//
//  Board.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import Foundation
import RealmSwift

//class RealmBoards: Object {
//  let myBoards = List<Board>()
//  let invitedBoards = List<Board>()
//}

//class Dog: Object, Codable {
//  @objc dynamic var name: String = ""
//  @objc dynamic var age: Int = 0
//
//  private enum CodingKeys: String, CodingKey {
//    case name
//    case age
//  }
//}

//class Dod: Object, Codable {
//  @objc dynamic var name: String = ""
//  @objc dynamic var text: String = ""
//  @objc dynamic var bucketNo: Int = 0
//
//}

//class Person: Object {
//  dynamic var name = ""
//  let dogs = List<Dog>()
//}


// @objc dynamic var

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
    var boards = [Board]()
    boards.append(contentsOf: myBoards)
    return boards
  }
  
  func fetchInvitedBoard() -> [Board] {
    var boards = [Board]()
    boards.append(contentsOf: invitedBoards)
    return boards
  }
}

class Board: Object, Codable {
  @objc dynamic var id: Int = 0
  @objc dynamic var title: String = ""
  @objc dynamic var color: String = ""
}

//extension Board: Hashable {
//  static func == (lhs: Board, rhs: Board) -> Bool {
//    return lhs.id == rhs.id && lhs.title == rhs.title
//  }
//
//  func hash(into hasher: inout Hasher) {
//    hasher.combine(id)
//    hasher.combine(title)
//  }
//}

