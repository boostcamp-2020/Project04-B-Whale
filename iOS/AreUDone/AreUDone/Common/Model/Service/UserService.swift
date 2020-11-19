//
//  UserService.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/19.
//

import Foundation
import NetworkFramework

protocol UserServiceProtocol {
  
}

class UserService: UserServiceProtocol {
  private let router: Routable
  
  init(router: Routable) {
    self.router = router
  }
  
}

//extension Routable where Self: Open {
//  func openURL() {
//
//  }
//}
