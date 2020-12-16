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
  func updateList(ofId listId: Int, position: Double?, title: String?, completionHandler: @escaping (Result<Void, APIError>) -> Void)
}

extension ListServiceProtocol {

  func updateList(ofId listId: Int, position: Double? = nil, title: String? = nil, completionHandler: @escaping (Result<Void, APIError>) -> Void) {
    updateList(ofId: listId, position: position, title: title, completionHandler: completionHandler)
  }
}

class ListService: ListServiceProtocol {
  
  // MARK: - Property
  
  private let router: Routable
  private let localDataSource: ListLocalDataSourceable?
  
  // MARK: - Initializer
  
  init(router: Routable, localDataSource: ListLocalDataSourceable? = nil) {
    self.router = router
    self.localDataSource = localDataSource
  }
  
  
  // MARK: - Method
  
  func createList(withBoardId boardId: Int, title: String, completionHandler: @escaping (Result<ListOfBoard, APIError>) -> Void) {
    let endPoint = ListEndPoint.createList(boardId: boardId, title: title)
    router.request(route: endPoint) { (result: Result<ListOfBoard, APIError>) in
      DispatchQueue.main.async {
        
        switch result {
        case .success(_):
          completionHandler(result)
          
        case .failure(_):
          
          if let localDataSource = self.localDataSource {
            let orderedEndPoint = OrderedEndPoint(value: endPoint.toDictionary())
            localDataSource.save(with: boardId, orderedEndPoint: orderedEndPoint) { object in
              completionHandler(.success(object))
            }
          }
          
          completionHandler(result)
        }
      }
    }
  }
  
  func deleteList(withListId listId: Int, completionHandler: @escaping (Result<Void, APIError>) -> Void) {
    router.request(route: ListEndPoint.deleteList(listId: listId)) { result in
      completionHandler(result)
    }
  }
  
  func updateList(ofId listId: Int, position: Double?, title: String?, completionHandler: @escaping (Result<Void, APIError>) -> Void) {
    router.request(route: ListEndPoint.updateList(listId: listId, position: position, title: title)) { result in
      completionHandler(result)
    }
  }
}

