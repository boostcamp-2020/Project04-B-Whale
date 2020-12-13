//
//  Realm+.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/13.
//

import Foundation
import RealmSwift

extension Realm {
  func writeOnMain(handler: @escaping () -> Void) {
    DispatchQueue.main.async {
      autoreleasepool{
        try! self.write {
          handler()
        }
      }
    }
  }
  
  func writeOnMain(object: Object, handler: @escaping (Object) -> Void) {
    DispatchQueue.main.async {
      autoreleasepool{
        try! self.write {
          handler(object)
        }
      }
    }
  }
}

