//
//  CommentService.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/19.
//

import Foundation
import NetworkFramework

protocol CommentServiceProtocol {
  
  func deleteComment(with commentId: Int, compeletionHandler: @escaping ((Result<Void, APIError>) -> Void))
}

class CommentService: CommentServiceProtocol {
  
  // MARK: - Property
  
  private let router: Routable
  
  
  // MARK: - Initializer
  
  init(router: Routable) {
    self.router = router
  }
  
  
  // MARK: - Method
  func createComment() {
    
  }
  
  func deleteComment(with commentId: Int, compeletionHandler: @escaping ((Result<Void, APIError>) -> Void)) {
    router.request(route: CommentEndPoint.deleteComment(commentId: commentId)) { (result: Result<Void, APIError>) in
      compeletionHandler(result)
    }
  }
}
