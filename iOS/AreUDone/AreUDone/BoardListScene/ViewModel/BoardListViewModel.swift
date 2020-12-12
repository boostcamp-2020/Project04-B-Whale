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
  
  func fetchBoardId(at indexPath: IndexPath, handler: (Int) -> Void)
  func changeBoardOption(option: FetchBoardOption)
  func fetchBoard()
}

final class BoardListViewModel: BoardListViewModelProtocol {
  
  // MARK: - Property
  
  private let boardService: BoardServiceProtocol
  
  private var initializeBoardListCollectionViewHandler: (([Board]) -> Void)?
  private var updateBoardListCollectionViewHandler: (([Board]) -> Void)?
  
  private var boards: [[Board]] = Array(repeating: [], count: 2)
  
  private var fetchBoardOption: FetchBoardOption = .myBoards {
    didSet {
      fetchBoard()
    }
  }

  
  // MARK: - Initializer
  
  init(boardService: BoardServiceProtocol) {
    self.boardService = boardService
  }
  
  
  // MARK: - Method
  
  func fetchBoardId(at indexPath: IndexPath, handler: (Int) -> Void) {
    let board = boards[indexPath.section][indexPath.item]
    handler(board.id)
  }
  
  func changeBoardOption(option: FetchBoardOption) {
    fetchBoardOption = option
  }
  
  func fetchBoard() {
    boardService.fetchAllBoards() { result in
      switch result {
      case .success(let boards):
        self.boards[0] = boards.myBoards
        self.boards[1] = boards.invitedBoards
        
        if self.fetchBoardOption == .myBoards {
          self.updateBoardListCollectionViewHandler?(boards.myBoards)
        } else {
          self.updateBoardListCollectionViewHandler?(boards.invitedBoards)
        }
        
        
        
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
