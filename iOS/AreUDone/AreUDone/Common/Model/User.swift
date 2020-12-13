//
//  User.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/04.
//

import Foundation
import RealmSwift

class User: Object, Codable {
  @objc dynamic var id: Int = 0
  @objc dynamic var name: String = ""
  @objc dynamic var profileImageUrl: String = ""
}
