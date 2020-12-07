//
//  BoardListViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import Foundation

protocol BoardListViewModelProtocol {
  func bindingInitializeBoardListCollectionView(handler: @escaping ([Board]) -> Void)
  func bindingUpdateBoardListCollectionView(handler: @escaping ([Board]) -> Void)
  
  func fetchMyBoard()
  func fetchInvitedBoard()
}

class BoardListViewModel: BoardListViewModelProtocol {
  
  // MARK: - Property
  
  private let boardService: BoardServiceProtocol
  
  private var initializeBoardListCollectionViewHandler: (([Board]) -> Void)?
  private var updateBoardListCollectionViewHandler: (([Board]) -> Void)?
  
  
  // MARK: - Initializer
  
  init(boardService: BoardServiceProtocol) {
    self.boardService = boardService
  }
  
  
  // MARK: - Method
  
  func fetchMyBoard() {
    boardService.fetchAllBoards() { result in
      switch result {
      case .success(let boards):
        self.updateBoardListCollectionViewHandler?(boards.myBoards)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func fetchInvitedBoard() {
    boardService.fetchAllBoards() { result in
      switch result {
      case .success(let boards):
        self.updateBoardListCollectionViewHandler?(boards.invitedBoards)
      case .failure(let error):
        print(error)
      }
    }
  }
}


// MARK: - Extension bindUI

extension BoardListViewModel {
  
  func bindingInitializeBoardListCollectionView(handler: @escaping ([Board]) -> Void) {
    initializeBoardListCollectionViewHandler = handler
  }
  
  func bindingUpdateBoardListCollectionView(handler: @escaping ([Board]) -> Void) {
    updateBoardListCollectionViewHandler = handler
  }
}
