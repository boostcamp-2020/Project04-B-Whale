//
//  UserDefaultStore.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/08.
//

import Foundation

class UserIdStore {
  
  static func saveAtUserDefault(with items: [String: Any]) {
    if let userId = items["userId"] {
      UserInfo.shared.userId = "\(userId)"
    }
  }
}
