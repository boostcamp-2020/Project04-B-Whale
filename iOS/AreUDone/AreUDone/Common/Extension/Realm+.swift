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
      do {
        try self.write {
          handler()
        }
      } catch(let error) {
        print(error)
      }
    }
  }
  
  func writeOnMain(object: Object, handler: @escaping (Object) -> Void) {
    DispatchQueue.main.async {
      do {
        try self.write {
          handler(object)
        }
      } catch (let error) {
        print(error)
      }
    }
  }
}

