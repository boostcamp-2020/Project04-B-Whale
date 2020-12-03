//
//  CardDetail.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/25.
//

import Foundation

struct CardDetail: Codable {
  
  let id: Int
  let title: String
  let content: String?
  let dueDate: String
  let comments: [Comment]?
  let board: Board
  let list: List
  
  struct Comment: Codable, Hashable {
    
    static func == (lhs: Comment, rhs: Comment) -> Bool {
      return lhs.id == rhs.id &&
        lhs.content == rhs.content &&
        lhs.createdAt == rhs.createdAt &&
        lhs.user == rhs.user
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
      hasher.combine(content)
      hasher.combine(createdAt)
      hasher.combine(user)
    }
    
    let id: Int
    let content: String
    let createdAt: String
    let user: User
    
    struct User: Codable, Hashable {
      let id: Int
      let name: String
      let profileImageUrl: String
    }
  }
  
  struct Board: Codable {
    let id: Int
    let title: String
  }
  
  struct List: Codable {
    let id: Int
    let title: String
  }
}
