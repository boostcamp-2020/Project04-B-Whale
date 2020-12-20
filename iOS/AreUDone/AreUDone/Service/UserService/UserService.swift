//
//  UserService.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/19.
//

import Foundation
import NetworkFramework

protocol UserServiceProtocol {
  
  func fetchMyInfo(completionHandler: @escaping ((Result<User, APIError>) -> Void))
  func fetchUserInfo(userName: String, completionHandler: @escaping ((Result<[User], APIError>) -> Void))
}

final class UserService: UserServiceProtocol {
  
  // MARK: - Property
  
  private let router: Routable
  
  
  // MARK: - Initializer
  
  init(router: Routable) {
    self.router = router
  }
  
  
  // MARK: - Method
  
  func fetchMyInfo(completionHandler: @escaping ((Result<User, APIError>) -> Void)) {
    router.request(route: UserEndPoint.fetchMyInfo) { (result: Result<User, APIError>) in
      completionHandler(result)
    }
  }
  
  func fetchUserInfo(userName: String, completionHandler: @escaping ((Result<[User], APIError>) -> Void)) {
    let endPoint = UserEndPoint.fetchUserInfo(userName: userName)
    router.request(route: endPoint) { (result: Result<[User], APIError>)  in
      completionHandler(result)
    }
  }
}
