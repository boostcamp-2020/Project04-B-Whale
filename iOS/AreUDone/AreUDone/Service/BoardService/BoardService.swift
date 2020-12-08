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
  func deleteBoard(with boardId: Int, completionHandler: @escaping (Result<Boards, APIError>) -> Void)
  
  func fetchBoardDetail(with boardId: Int, completionHandler: @escaping (Result<BoardDetail, APIError>) -> Void)
  func requestInvitation(with boardId: Int, and userId: Int, completionHandler: @escaping (Result<Void, APIError>) -> Void)
}

final class BoardService: BoardServiceProtocol {
  
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
  
  func createBoard(withTitle title: String, color: String, completionHandler: @escaping (Result<Void, APIError>) -> Void) {
    router.request(route: BoardEndPoint.createBoard(title: title, color: color)) { result in
      completionHandler(result)
    }
  }
  
  func updateBoard(withBoardId boardId: Int, title: String, completionHandler: @escaping (Result<Void, APIError>) -> Void) {
    router.request(route: BoardEndPoint.updateBoard(boardId: boardId, title: title)) { result in
      completionHandler(result)
    }
  }
  
  func deleteBoard(with boardId: Int, completionHandler: @escaping (Result<Boards, APIError>) -> Void) {
    router.request(route: BoardEndPoint.deleteBoard(boardId: boardId)) { result in
      completionHandler(result)
    }
  }
  
  func fetchBoardDetail(with boardId: Int, completionHandler: @escaping (Result<BoardDetail, APIError>) -> Void) {
    router.request(route: BoardEndPoint.fetchBoardDetail(boardId: boardId)) { result in
      completionHandler(result)
    }
  }
  
  func requestInvitation(with boardId: Int, and userId: Int, completionHandler: @escaping (Result<Void, APIError>) -> Void) {
    router.request(route: BoardEndPoint.inviteUserToBoard(boardId: boardId, userId: userId)) { result in
      completionHandler(result)
    }
  }
}
