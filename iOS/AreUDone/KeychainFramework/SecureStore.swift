//
//  SecureStore.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/12.
//

import Foundation
import Security

public struct SecureStore {
  
  // MARK:- Property
  
  let secureStoreQueryable: SecureStoreQueryable
  
  
  // MARK:- Initializer
  
  public init(secureStoreQueryable: SecureStoreQueryable) {
    self.secureStoreQueryable = secureStoreQueryable
  }
  
  
  // MARK:- Method
  
  public func setValue(_ value: String, for userAccount: String) throws {
    guard let encodedPassword = value.data(using: .utf8) else {
      throw SecureStoreError.stringToDataConversionError
    }
    
    var query = secureStoreQueryable.query
    query[String(kSecAttrAccount)] = userAccount
    
    var status = SecItemCopyMatching(query as CFDictionary, nil)
    
    switch status {
    case errSecSuccess:
      var attributesToUpdate: [String: Any] = [:]
      attributesToUpdate[String(kSecValueData)] = encodedPassword
      
      status = SecItemUpdate(query as CFDictionary,
                                   attributesToUpdate as CFDictionary)
      if status != errSecSuccess {
        throw error(from: status)
      }
    
    case errSecItemNotFound:
      query[String(kSecValueData)] = encodedPassword
      status = SecItemAdd(query as CFDictionary, nil)
      
      if status != errSecSuccess {
        throw error(from: status)
      }
      
    default:
      throw error(from: status)
    }
  }
  
  public func getValue(for userAccount: String) throws -> String? {
    var query = secureStoreQueryable.query
    query[String(kSecMatchLimit)] = kSecMatchLimitOne
    query[String(kSecReturnAttributes)] = kCFBooleanTrue
    query[String(kSecReturnData)] = kCFBooleanTrue
    query[String(kSecAttrAccount)] = userAccount
    
    var queryResult: AnyObject?
    let status = withUnsafeMutablePointer(to: &queryResult) {
      SecItemCopyMatching(query as CFDictionary, $0)
    }
    
    switch status {
    case errSecSuccess:
      guard
        let queriedItem = queryResult as? [String: Any],
        let passwordData = queriedItem[String(kSecValueData)] as? Data,
        let password = String(data: passwordData, encoding: .utf8)
      else {
        throw SecureStoreError.dataToStringConversionError
      }
      return password
      
    case errSecItemNotFound:
      return nil
      
    default:
      throw error(from: status)
    }
  }
  
  public func removeValue(for userAccount: String) throws {
    var query = secureStoreQueryable.query
    query[String(kSecAttrAccount)] = userAccount
    
    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw error(from: status)
    }
  }
  
  public func removeAllValues() throws {
    let query = secureStoreQueryable.query
    
    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw error(from: status)
    }
  }
  
  private func error(from status: OSStatus) -> SecureStoreError {
    let message = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")
    return SecureStoreError.unhandledError(message: message)
  }
}
