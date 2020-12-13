//
//  BoardDetail.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/02.
//

import Foundation
import RealmSwift

class BoardDetail: Object, Codable {
  @objc dynamic var id: Int = 0
  @objc dynamic var creator: User?
  @objc dynamic var title = ""
  @objc dynamic var color: String = ""
  var invitedUsers = List<User>()
  var lists = List<ListOfBoard>()
  
  required convenience init(from decoder: Decoder) throws {
    self.init()
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id = try container.decode(Int.self, forKey: .id)
    self.creator = try container.decode(User.self, forKey: .creator)
    self.title = try container.decode(String.self, forKey: .title)
    self.color = try container.decode(String.self, forKey: .color)
    
    let decodedInvitedUsers =
      try container.decodeIfPresent([User].self, forKey: .invitedUsers) ?? [User()]
    invitedUsers.append(objectsIn: decodedInvitedUsers)
    
    let decodedLists =
      try container.decodeIfPresent([ListOfBoard].self, forKey: .lists) ?? [ListOfBoard()]
    lists.append(objectsIn: decodedLists)
  }
  
  
  func fetchInvitedUsers() -> [User] {
    var users = [User]()
    users.append(contentsOf: invitedUsers)
    return users
  }
  
  func fetchLists() -> [ListOfBoard] {
    var lists = [ListOfBoard]()
    lists.append(contentsOf: lists)
    return lists
  }
}
