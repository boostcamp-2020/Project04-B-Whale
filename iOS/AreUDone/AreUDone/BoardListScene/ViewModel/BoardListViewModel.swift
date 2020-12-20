//
//  BoardListViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import Foundation

protocol BoardListViewModelProtocol {
  
  func bindingUpdateBoardListCollectionView(handler: @escaping ([Board]) -> Void)
  func bindingBoardDidTapped(handler: @escaping (Int) -> Void)
  func bindingEmptyIndicatorView(handler: @escaping (Bool) -> Void)
  
  func fetchBoard()
  func pushBoardDetail(to board: Board)
  func changeBoardOption(option: FetchBoardOption)
}

final class BoardListViewModel: BoardListViewModelProtocol {
  
  // MARK: - Property
  
  private let boardService: BoardServiceProtocol
  
  private var updateBoardListCollectionViewHandler: (([Board]) -> Void)?
  private var boardDidTappedHandler: ((Int) -> Void)?
  private var emptyIndicatorViewHandler: ((Bool) -> Void)?
  
  private var fetchBoardOption: FetchBoardOption = .myBoards {
    didSet {
      guard oldValue != fetchBoardOption else { return }
      fetchBoard()
    }
  }

  
  // MARK: - Initializer
  
  init(boardService: BoardServiceProtocol) {
    self.boardService = boardService
  }
  
  
  // MARK: - Method
  
  func fetchBoard() {
    boardService.fetchAllBoards() { result in
      switch result {
      case .success(let boards):
        if self.fetchBoardOption == .myBoards {
          self.updateBoardListCollectionViewHandler?(boards.fetchMyBoard())
          self.emptyIndicatorViewHandler?(boards.fetchMyBoard().isEmpty)
          
        } else {
          self.updateBoardListCollectionViewHandler?(boards.fetchInvitedBoard())
          self.emptyIndicatorViewHandler?(boards.fetchInvitedBoard().isEmpty)
        }
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func pushBoardDetail(to board: Board) {
    boardDidTappedHandler?(board.id)
  }
  
  func changeBoardOption(option: FetchBoardOption) {
    fetchBoardOption = option
  }
}


// MARK: - Extension BindUI

extension BoardListViewModel {
  
  func bindingUpdateBoardListCollectionView(handler: @escaping ([Board]) -> Void) {
    updateBoardListCollectionViewHandler = handler
  }
  
  func bindingBoardDidTapped(handler: @escaping (Int) -> Void) {
    boardDidTappedHandler = handler
  }
  
  func bindingEmptyIndicatorView(handler: @escaping (Bool) -> Void) {
    emptyIndicatorViewHandler = handler
  }
}
