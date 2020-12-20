//
//  SecureStoreQueryable.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/12.
//

import Foundation

public protocol SecureStoreQueryable {
  
  var query: [String: Any] { get }
}

public struct GenericPasswordQueryable {
  
  // MARK:- Property
  
  let service: String
  let accessGroup: String?
  
  
  // MARK:- Initializer
  
  public init(service: String, accessGroup: String? = nil) {
    self.service = service
    self.accessGroup = accessGroup
  }
}

extension GenericPasswordQueryable: SecureStoreQueryable {
  
  public var query: [String: Any] {
    var query: [String: Any] = [:]
    
    query[String(kSecClass)] = kSecClassGenericPassword
    query[String(kSecAttrService)] = service
    
    return query
  }
}
