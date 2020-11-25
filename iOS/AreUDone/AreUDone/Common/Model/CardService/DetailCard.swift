//
//  DetailCard.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/25.
//

import Foundation

struct DetailCard: Codable {
  let id: Int
  let title: String
  let content: String
  let comment: [Comment]
  let board: Board
  let list: List
  
  struct Comment: Codable {
    let id: Int
    let content: String
    let createdAt: String
    let user: User
    
    struct User: Codable {
      let id: Int
      let name: String
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
