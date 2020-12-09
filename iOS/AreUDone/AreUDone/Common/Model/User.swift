//
//  User.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/04.
//

import Foundation

struct User: Codable, Hashable {
  let id: Int
  let name: String
  let profileImageUrl: String
}
