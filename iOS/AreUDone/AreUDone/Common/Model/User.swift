//
//  User.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/04.
//

import Foundation
import RealmSwift

final class User: Object, Codable {
  
  // MARK: - Property
  
  @objc dynamic var id: Int = 0
  @objc dynamic var name: String = ""
  @objc dynamic var profileImageUrl: String = ""
}


// MARK: - Extension Hashable

extension User {
  
  override func isEqual(_ object: Any?) -> Bool {
    guard let other = object as? User else { return false }
    
    return self.id == other.id
  }
  
  override var hash: Int {
    return self.id.hashValue
  }
}
