//
//  BoardDetail.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/02.
//

import Foundation

struct BoardDetail: Codable {
  let id: Int
  let creator: Creator
  let title, color: String
  let invitedUsers: [InvitedUser]
  var lists: [List]
}

// MARK: - Creator
struct Creator: Codable {
  let id: Int
  let name, profileImageUrl: String
}

struct InvitedUser: Codable, Hashable {
  static func == (lhs: InvitedUser, rhs: InvitedUser) -> Bool {
    return lhs.id == rhs.id
  }
  
  let id: Int
  let name, profileImageUrl: String
}
