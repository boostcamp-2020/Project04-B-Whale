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
  func addBoard(withTitle title: String, completionHandler: @escaping (Result<Boards, APIError>) -> Void)
  func editBoard(withBoardId boardId: Int, title: String, completionHandler: @escaping (Result<Boards, APIError>) -> Void)
  func deleteBoard(withBoardId boardId: Int, completionHandler: @escaping (Result<Boards, APIError>) -> Void)
  
  func fetchBoardDetail(withBoardId boardId: Int, completionHandler: @escaping (Result<BoardDetail, APIError>) -> Void)
}

class BoardService: BoardServiceProtocol {
  
  // MARK: - Property
  
  private let router: Routable
  
  
  // MARK: - Initializer
  
  init(router: Routable) {
    self.router = router
  }
  
  
  // MARK: - Method
  
  func fetchAllBoards(completionHandler: @escaping (Result<Boards, APIError>) -> Void ) {
    router.request(route: BoardEndPoint.fetchAllBoards) { result in
      completionHandler(result)
    }
  }
  
  func addBoard(withTitle title: String, completionHandler: @escaping (Result<Boards, APIError>) -> Void) {
    router.request(route: BoardEndPoint.addBoard(title: title)) { result in
      completionHandler(result)
    }
  }
  
  func editBoard(withBoardId boardId: Int, title: String, completionHandler: @escaping (Result<Boards, APIError>) -> Void) {
    router.request(route: BoardEndPoint.updateBoard(boardId: boardId, title: title)) { result in
      completionHandler(result)
    }
  }
  
  func deleteBoard(withBoardId boardId: Int, completionHandler: @escaping (Result<Boards, APIError>) -> Void) {
    router.request(route: BoardEndPoint.deleteBoard(boardId: boardId)) { result in
      completionHandler(result)
    }
  }
  
  func fetchBoardDetail(withBoardId boardId: Int, completionHandler: @escaping (Result<BoardDetail, APIError>) -> Void) {
    router.request(route: BoardEndPoint.fetchBoardDetail(boardId: boardId)) { result in
      completionHandler(result)
    }
  }
  
}
