//
//  BoardListViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import Foundation

protocol BoardListViewModelProtocol {
  func bindingInitializeBoardListCollectionView(handler: @escaping (Boards) -> Void)
  func bindingUpdateBoardListCollectionView(handler: @escaping (Boards) -> Void)
  
  func initializeBoardListCollectionView()
  func updateBoardListCollectionView()
}

class BoardListViewModel: BoardListViewModelProtocol {
  
  // MARK: - Property
  
  private let boardService: BoardServiceProtocol
  
  private var initializeBoardListCollectionViewHandler: ((Boards) -> Void)?
  private var updateBoardListCollectionViewHandler: ((Boards) -> Void)?
  
  
  // MARK: - Initializer
  
  init(boardService: BoardServiceProtocol) {
    self.boardService = boardService
  }
  
  
  // MARK: - Method
  
  func initializeBoardListCollectionView() {
    fetchAllBoards(with: initializeBoardListCollectionViewHandler)
  }
  
  func updateBoardListCollectionView() {
    fetchAllBoards(with: updateBoardListCollectionViewHandler)
  }
  
  func fetchAllBoards(with handler: ((Boards) -> Void)?) {
    boardService.fetchAllBoards() { result in
      switch result {
      case .success(let boards):
        handler?(boards)
      case .failure(let error):
        print(error)
      }
    }
  }
}


// MARK: - Extension


// MARK: Binding Handler

extension BoardListViewModel {
  
  func bindingInitializeBoardListCollectionView(handler: @escaping (Boards) -> Void) {
    initializeBoardListCollectionViewHandler = handler
  }
  
  func bindingUpdateBoardListCollectionView(handler: @escaping (Boards) -> Void) {
    updateBoardListCollectionViewHandler = handler
  }
}
