//
//  ActivityService.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/19.
//

import Foundation
import NetworkFramework

protocol ActivityServiceProtocol {
  
  func fetchActivities(withBoardId boardId: Int, completionHandler: @escaping (Result<Activities, APIError>) -> Void )
}

class ActivityService: ActivityServiceProtocol {
 
  
  // MARK: - Property
  
  private let router: Routable
  
  
  // MARK: - Initializer
  
  init(router: Routable) {
    self.router = router
  }
  
  
  // MARK: - Method
  
  func fetchActivities(withBoardId boardId: Int, completionHandler: @escaping (Result<Activities, APIError>) -> Void ) {
    router.request(route: ActivityEndPoint.fetchActivities(boardId: boardId)) { result in
      completionHandler(result)
    }
  }
}
