//
//  BoardService.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/19.
//

import Foundation
import NetworkFramework

protocol BoardServiceProtocol: class {
  
  /* BoardService 는 로컬에서 갱신을 하지 않고 매번 API 로 데이터를 받아오기 때문에 fetchAllBoards 에서만 처리
   API 받아오고 저장된 데이터와 비교하여 같으면 save 하지 않고 같지 않으면 새로 save?
   
   */
  
  
  func fetchAllBoards(completionHandler: @escaping (Result<Boards, APIError>) -> Void) // success 시 API로부터 받아오고 realm 에 save, fail 시 realm 으로부터 load
  func createBoard(withTitle title: String, color: String, completionHandler: @escaping (Result<Void, APIError>) -> Void)
  func updateBoard(withBoardId boardId: Int, title: String, completionHandler: @escaping (Result<Void, APIError>) -> Void)
  func deleteBoard(with boardId: Int, completionHandler: @escaping (Result<Boards, APIError>) -> Void)
  
  func fetchBoardDetail(with boardId: Int, completionHandler: @escaping (Result<BoardDetail, APIError>) -> Void)
  func requestInvitation(withBoardId boardId: Int, andUserId userId: Int, completionHandler: @escaping (Result<Void, APIError>) -> Void)
}

final class BoardService: BoardServiceProtocol {
  
  // MARK: - Property
  
  private let router: Routable // remote
  private let localDataSource: BoardLocalDataSourceable? // local (realm)
  
  
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
        completionHandler(.success(boards))
          self.localDataSource?.save(boards: boards) // 같은 쓰레드??? 에서 돌려야한다고함
        
      case .failure(_):
          if let boards = self.localDataSource?.loadBoards() {
            completionHandler(.success(boards))
          } else {
            completionHandler(.failure(.data))
          }
        break
      }
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
    router.request(route: BoardEndPoint.fetchBoardDetail(boardId: boardId)) { (result: Result<BoardDetail, APIError>) in
      switch result {
      case .success(let boardDetail):
        completionHandler(.success(boardDetail))
          self.localDataSource?.save(boardDetail: boardDetail)
        
      case .failure(_):
          if let boardDetail = self.localDataSource?.loadBoardDetail(ofId: boardId) {
            completionHandler(.success(boardDetail))
          } else {
            completionHandler(.failure(.data))
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

