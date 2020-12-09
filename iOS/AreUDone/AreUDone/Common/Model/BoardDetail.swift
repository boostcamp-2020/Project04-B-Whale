//
//  BoardDetail.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/02.
//

import Foundation

struct BoardDetail: Codable {
  let id: Int
  let creator: User
  let title, color: String
  let invitedUsers: [User]
  var lists: [List]
}
