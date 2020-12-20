//
//  CardDetail.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/25.
//

import Foundation
import RealmSwift

final class CardDetail: Object, Codable {
  
  // MARK: - Property
  
  @objc dynamic var id: Int = 0
  @objc dynamic var title: String = ""
  @objc dynamic var content: String = ""
  @objc dynamic var dueDate: String = ""
  var members = List<User>()
  var comments = List<CardDetailComment>()
  @objc dynamic var board: CardDetailBoard?
  @objc dynamic var list: CardDetailList?
  
  override class func primaryKey() -> String? {
    return "id"
  }
  
  
  // MARK: - Initializer
  
  required convenience init(from decoder: Decoder) throws {
    self.init()
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id = try container.decode(Int.self, forKey: .id)
    self.title = try container.decode(String.self, forKey: .title)
    self.content = try container.decode(String.self, forKey: .content)
    self.dueDate = try container.decode(String.self, forKey: .dueDate)
    self.board = try container.decode(CardDetailBoard.self, forKey: .board)
    self.list = try container.decode(CardDetailList.self, forKey: .list)
    let decodedMembers = try container.decodeIfPresent([User].self, forKey: .members) ?? []
    let decodedComments = try container.decodeIfPresent([CardDetailComment].self, forKey: .comments) ?? []
    
    self.members.append(objectsIn: decodedMembers)
    self.comments.append(objectsIn: decodedComments)
  }
  
  
  // MARK: - Method
  
  func fetchMembers() -> [User] {
    return Array(members)
  }
  
  func fetchComment() -> [CardDetailComment] {
    return Array(comments)
  }
}

final class CardDetailComment: Object, Codable {
  
  // MARK: - Property
  
  @objc dynamic var id: Int = 0
  @objc dynamic var content: String = ""
  @objc dynamic var createdAt: String = ""
  @objc dynamic var user: User?
  
  override class func primaryKey() -> String? {
    return "id"
  }
  
  
  // MARK: - Initializer
  
  required convenience init(from decoder: Decoder) throws {
    self.init()
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id = try container.decode(Int.self, forKey: .id)
    self.content = try container.decode(String.self, forKey: .content)
    self.createdAt = try container.decode(String.self, forKey: .createdAt)
    self.user = try container.decode(User.self, forKey: .user)
  }
  
  
  // MARK: - Method
  
  override func isEqual(_ object: Any?) -> Bool {
    guard let other = object as? CardDetailComment else { return false }
    
    return self.id == other.id
  }
}

final class CardDetailBoard: Object, Codable {
  
  // MARK: - Property
  
  @objc dynamic var id: Int = 0
  @objc dynamic var title: String = ""
  
  
  // MARK: - Initializer
  
  required convenience init(from decoder: Decoder) throws {
    self.init()
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id = try container.decode(Int.self, forKey: .id)
    self.title = try container.decode(String.self, forKey: .title)
  }
}


final class CardDetailList: Object, Codable {
  
  // MARK: - Property
  
  @objc dynamic var id: Int = 0
  @objc dynamic var title: String = ""
  
  
  // MARK: - Initializer
  
  required convenience init(from decoder: Decoder) throws {
    self.init()
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id = try container.decode(Int.self, forKey: .id)
    self.title = try container.decode(String.self, forKey: .title)
  }
}
