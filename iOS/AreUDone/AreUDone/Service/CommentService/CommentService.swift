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
  private let commentLocalDataSource: CommentLocalDataSourceable?
  
  
  // MARK: - Initializer
  
  init(router: Routable, commentLocalDataSource: CommentLocalDataSourceable) {
    self.router = router
    self.commentLocalDataSource = commentLocalDataSource
  }
  
  
  // MARK: - Method
  
  func createComment(with cardId: Int, content: String, completionHandler: @escaping ((Result<CardDetailComment, APIError>) -> Void)) {
    router.request(route: CommentEndPoint.createComment(cardId: cardId, content: content)) { (result: Result<CardDetailComment, APIError>) in
      switch result {
      case .success(let comment):
        completionHandler(result)
        self.commentLocalDataSource?.save(comment: comment, forCardId: cardId)
        
      case .failure(_):
        completionHandler(.failure(.data))
      }
      
    }
  }
  
  func deleteComment(with commentId: Int, compeletionHandler: @escaping ((Result<Void, APIError>) -> Void)) {
    router.request(route: CommentEndPoint.deleteComment(commentId: commentId)) { (result: Result<Void, APIError>) in
      switch result {
      case .success(()):
        compeletionHandler(result)
        self.commentLocalDataSource?.deleteComment(for: commentId)
        
      case .failure(_):
        compeletionHandler(.failure(.data))
      }
    }
  }
}
