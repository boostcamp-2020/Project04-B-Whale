//
//  Activity.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/02.
//

import Foundation

struct Activities: Codable {
  let activities: [Activity]
}

struct Activity: Codable {
  let id: Int
  let boardId: Int
  let content: String
  let createdAt: String
}
