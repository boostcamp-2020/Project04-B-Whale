//
//  UserInfo.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/08.
//

import Foundation

@propertyWrapper
struct UserDefault {
  
  // MARK: - Property
  
  private let key: String
  
  var wrappedValue: String {
    get { UserDefaults.standard.string(forKey: key) ?? "" }
    set { UserDefaults.standard.set(newValue, forKey: key) }
  }
  
  init(key: String) {
    self.key = key
  }
}


final class UserInfo {
  
  // MARK: - Property
  
  static let shared = UserInfo()
  
  @UserDefault(key: "userId") var userId: String
}
