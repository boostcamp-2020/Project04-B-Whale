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

final class Keychain: Keychainable {
  
  // MARK: - Property
  
  static let shared = Keychain()
  
  private var secureStore: SecureStore {
    let queryable = GenericPasswordQueryable(service: KeyChainConstant.serviceName)
    return SecureStore(secureStoreQueryable: queryable)
  }
  
  
  // MARK: - Method
  
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
