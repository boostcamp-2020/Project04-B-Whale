//
//  CommentService.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/19.
//

import Foundation
import NetworkFramework

protocol CommentServiceProtocol {
  
  func createComment(with cardId: Int, content: String, completionHandler: @escaping ((Result<CardDetailComment, APIError>) -> Void))
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
  
  func createComment(with cardId: Int, content: String, completionHandler: @escaping ((Result<CardDetailComment, APIError>) -> Void)) {
    router.request(route: CommentEndPoint.createComment(cardId: cardId, content: content)) { (result: Result<CardDetailComment, APIError>) in
      completionHandler(result)
    }
  }
  
  func deleteComment(with commentId: Int, compeletionHandler: @escaping ((Result<Void, APIError>) -> Void)) {
    router.request(route: CommentEndPoint.deleteComment(commentId: commentId)) { (result: Result<Void, APIError>) in
      compeletionHandler(result)
    }
  }
}
