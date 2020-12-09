//
//  UserService.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/19.
//

import Foundation
import NetworkFramework

protocol UserServiceProtocol {
  
  func requestMe(completionHandler: @escaping ((Result<User, APIError>) -> Void))
  func fetchUserInfo(userName: String, completionHandler: @escaping ((Result<[User], APIError>) -> Void))
}

class UserService: UserServiceProtocol {
  
  // MARK: - Property
  
  private let router: Routable
  
  
  // MARK: - Initializer
  
  init(router: Routable) {
    self.router = router
  }
  
  
  // MARK: - Method
  
  func requestMe(completionHandler: @escaping ((Result<User, APIError>) -> Void)) {
    router.request(route: UserEndPoint.requestMe) { (result: Result<User, APIError>) in
      completionHandler(result)
    }
  }
  
  func fetchUserInfo(userName: String, completionHandler: @escaping ((Result<[User], APIError>) -> Void)) {
    router.request(route: UserEndPoint.searchUser(userName: userName)) { (result: Result<[User], APIError>)  in
      completionHandler(result)
    }
  }
}
