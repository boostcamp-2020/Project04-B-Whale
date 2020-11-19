//
//  Keychain.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/19.
//

import Foundation
import KeychainFramework

protocol Keychainable {
  func save(value: String, forKey key: String)
  func loadValue(forKey key: String) -> String?
  func removeValue(forKey key: String)
  func removeAll()
}

class Keychain: Keychainable {
  static let shared = Keychain()
  
  private var secureStore: SecureStore {
    let queryable = GenericPasswordQueryable(service: "AreUDone")
    return SecureStore(secureStoreQueryable: queryable)
  }
  
  func save(value: String, forKey key: String) {
    try? secureStore.setValue(value, for: key)
  }
  
  func loadValue(forKey key: String) -> String? {
    let value = try? secureStore.getValue(for: key)
    
    return value
  }
  
  func removeValue(forKey key: String) {
    try? secureStore.removeValue(for: key)
  }
  
  func removeAll() {
    try? secureStore.removeAllValues()
  }
}
