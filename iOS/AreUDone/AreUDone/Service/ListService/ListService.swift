//
//  ListService.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/19.
//

import Foundation
import NetworkFramework

protocol ListServiceProtocol {
  func createList(withBoardId boardId: Int, title: String, completionHandler: @escaping (Result<Void, APIError>) -> Void)
  func deleteList(withListId listId: Int, completionHandler: @escaping (Result<Void, APIError>) -> Void)
  func updateList(withListId listId: Int, position: Double?, title: String?, completionHandler: @escaping (Result<Void, APIError>) -> Void)
}

extension ListServiceProtocol {

  func updateList(withListId listId: Int, position: Double? = nil, title: String? = nil, completionHandler: @escaping (Result<Void, APIError>) -> Void) {
    updateList(withListId: listId, position: position, title: title, completionHandler: completionHandler)
  }
}

class ListService: ListServiceProtocol {
  
  // MARK: - Property
  
  private let router: Routable
  
  
  // MARK: - Initializer
  
  init(router: Routable) {
    self.router = router
  }
  
  
  // MARK: - Method
  
  func createList(withBoardId boardId: Int, title: String, completionHandler: @escaping (Result<Void, APIError>) -> Void) {
    router.request(route: ListEndPoint.createList(boardId: boardId, title: title)) { result in
      completionHandler(result)
    }
  }
  
  func deleteList(withListId listId: Int, completionHandler: @escaping (Result<Void, APIError>) -> Void) {
    router.request(route: ListEndPoint.deleteList(listId: listId)) { result in
      completionHandler(result)
    }
  }
  
  func updateList(withListId listId: Int, position: Double?, title: String?, completionHandler: @escaping (Result<Void, APIError>) -> Void) {
    router.request(route: ListEndPoint.updateList(listId: listId, position: position, title: title)) { result in
      completionHandler(result)
    }
  }
}
