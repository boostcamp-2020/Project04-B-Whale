//
//  BoardDetail.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/02.
//

import Foundation
import RealmSwift

final class BoardDetail: Object, Codable {
  
  // MARK: - Property
  
  @objc dynamic var id: Int = 0
  @objc dynamic var creator: User?
  @objc dynamic var title = ""
  @objc dynamic var color: String = ""
  var invitedUsers = List<User>()
  var lists = List<ListOfBoard>()
  
  override class func primaryKey() -> String? {
    return "id"
  }
  
  func fetchList(at index: Int) -> ListOfBoard {
    let list = lists[index]
    return ListOfBoard(value: list)
  }
  
  // MARK: - Initializer
  
  required convenience init(from decoder: Decoder) throws {
    self.init()
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id = try container.decode(Int.self, forKey: .id)
    self.creator = try container.decode(User.self, forKey: .creator)
    self.title = try container.decode(String.self, forKey: .title)
    self.color = try container.decode(String.self, forKey: .color)
    let decodedInvitedUsers = try container.decodeIfPresent([User].self, forKey: .invitedUsers) ?? []
    let decodedLists = try container.decodeIfPresent([ListOfBoard].self, forKey: .lists) ?? []
    
    invitedUsers.append(objectsIn: decodedInvitedUsers)
    lists.append(objectsIn: decodedLists)
  }
  
  
  // MARK: - Method
  
  func fetchInvitedUsers() -> [User] {
    return Array(invitedUsers)
  }
}
