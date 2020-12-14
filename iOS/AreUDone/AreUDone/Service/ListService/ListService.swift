//
//  ListService.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/19.
//

import Foundation
import NetworkFramework

protocol ListServiceProtocol {
  func createList(withBoardId boardId: Int, title: String, completionHandler: @escaping (Result<ListOfBoard, APIError>) -> Void)
  func deleteList(withListId listId: Int, completionHandler: @escaping (Result<Void, APIError>) -> Void)
  func updateList(withBoardId boardId: Int, listId: Int, position: Double?, title: String?, completionHandler: @escaping (Result<Void, APIError>) -> Void)
}

extension ListServiceProtocol {

  func updateList(withBoardId boardId: Int, listId: Int, position: Double? = nil, title: String? = nil, completionHandler: @escaping (Result<Void, APIError>) -> Void) {
    updateList(withBoardId: boardId, listId: listId, position: position, title: title, completionHandler: completionHandler)
  }
}

class ListService: ListServiceProtocol {
  
  // MARK: - Property
  
  private let router: Routable
  private let localDataSource: ListLocalDataSourceable? // local (realm)
  
  
  // MARK: - Initializer
  
  init(router: Routable, localDataSource: ListLocalDataSourceable? = nil) {
    self.router = router
    self.localDataSource = localDataSource
  }
  
  
  // MARK: - Method
  
  func createList(withBoardId boardId: Int, title: String, completionHandler: @escaping (Result<ListOfBoard, APIError>) -> Void) {
    router.request(route: ListEndPoint.createList(boardId: boardId, title: title)) { result in
      DispatchQueue.main.async {
        completionHandler(result)
      }
    }
  }
  
  func deleteList(withListId listId: Int, completionHandler: @escaping (Result<Void, APIError>) -> Void) {
    router.request(route: ListEndPoint.deleteList(listId: listId)) { result in
      completionHandler(result)
    }
  }
  
  func updateList(withBoardId boardId: Int, listId: Int, position: Double?, title: String?, completionHandler: @escaping (Result<Void, APIError>) -> Void) {
    router.request(route: ListEndPoint.updateList(listId: listId, position: position, title: title)) { result in
      switch result {
      case .success(_):
        completionHandler(.success(()))
        DispatchQueue.main.async {
          self.localDataSource?.updateList(ofBoardId: boardId, title: title, position: position, listId: listId)
        }
        
      case .failure(_):
        completionHandler(result)
        
        break
      }
    }
  }
}

