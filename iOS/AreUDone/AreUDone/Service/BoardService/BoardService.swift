//
//  BoardService.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/19.
//

import Foundation
import NetworkFramework

protocol BoardServiceProtocol: class {
  
  func fetchAllBoards(completionHandler: @escaping (Result<Boards, APIError>) -> Void) 
  func createBoard(withTitle title: String, color: String, completionHandler: @escaping (Result<Void, APIError>) -> Void)
  func updateBoard(withBoardId boardId: Int, title: String, completionHandler: @escaping (Result<Void, APIError>) -> Void)
  func deleteBoard(with boardId: Int, completionHandler: @escaping (Result<Void, APIError>) -> Void)
  
  func fetchBoardDetail(with boardId: Int, completionHandler: @escaping (Result<BoardDetail, APIError>) -> Void)
  func requestInvitation(withBoardId boardId: Int, andUserId userId: Int, completionHandler: @escaping (Result<Void, APIError>) -> Void)
}

final class BoardService: BoardServiceProtocol {
  
  // MARK: - Property
  
  private let router: Routable
  private let localDataSource: BoardLocalDataSourceable?
  
  
  // MARK: - Initializer
  
  init(router: Routable, localDataSource: BoardLocalDataSourceable? = nil) {
    self.router = router
    self.localDataSource = localDataSource
  }
  
  
  // MARK: - Method
  
  func fetchAllBoards(completionHandler: @escaping (Result<Boards, APIError>) -> Void ) {
    router.request(route: BoardEndPoint.fetchAllBoards) { (result: (Result<Boards, APIError>)) in
      switch result {
      case .success(let boards):
        completionHandler(result)
        self.localDataSource?.save(boards: boards)
      
      case .failure(_):
        DispatchQueue.main.async {
          if let boards = self.localDataSource?.loadBoards() {
            completionHandler(.success(boards))
          } else {
            completionHandler(result)
          }
        }
      
        break
      }
    }
  }
  
  func createBoard(withTitle title: String, color: String, completionHandler: @escaping (Result<Void, APIError>) -> Void) {
    let endPoint = BoardEndPoint.createBoard(title: title, color: color)
    
    router.request(route: endPoint) { result in
      switch result {
      case .success(_):
        completionHandler(.success(()))
        
      case .failure(_):
        if let localDataSource = self.localDataSource {
          // 실패 시 endpoint save
          let orderedEndpoint = OrderedEndPoint(value: endPoint.toDictionary())
          localDataSource.save(orderedEndPoint: orderedEndpoint)
          
          completionHandler(.success(()))
        } else {
          completionHandler(result)
        }
      }
    }
  }
  
  func updateBoard(withBoardId boardId: Int, title: String, completionHandler: @escaping (Result<Void, APIError>) -> Void) {
    router.request(route: BoardEndPoint.updateBoard(boardId: boardId, title: title)) { result in
      switch result {
      case .success(_):
        completionHandler(.success(()))
        DispatchQueue.main.async {
          self.localDataSource?.updateBoard(title: title, ofId: boardId)
        }
        
      case .failure(_):
        completionHandler(result)
        
        break
      }
    }
  }
  
  func deleteBoard(with boardId: Int, completionHandler: @escaping (Result<Void, APIError>) -> Void) {
    router.request(route: BoardEndPoint.deleteBoard(boardId: boardId)) { result in
      completionHandler(result)
    }
  }
  
  func fetchBoardDetail(with boardId: Int, completionHandler: @escaping (Result<BoardDetail, APIError>) -> Void) {
    router.request(route: BoardEndPoint.fetchBoardDetail(boardId: boardId)) { (result: Result<BoardDetail, APIError>) in
      switch result {
      case .success(let boardDetail):
        completionHandler(.success(boardDetail))
        self.localDataSource?.save(boardDetail: boardDetail)
        
      case .failure(_):
        DispatchQueue.main.async {
          if let boardDetail = self.localDataSource?.loadBoardDetail(ofId: boardId) {
            completionHandler(.success(boardDetail))
          } else {
            completionHandler(.failure(.data))
          }
        }
      }
    }
  }
  
  func requestInvitation(withBoardId boardId: Int, andUserId userId: Int, completionHandler: @escaping (Result<Void, APIError>) -> Void) {
    router.request(route: BoardEndPoint.inviteUserToBoard(boardId: boardId, userId: userId)) { result in
      completionHandler(result)
    }
  }
}


