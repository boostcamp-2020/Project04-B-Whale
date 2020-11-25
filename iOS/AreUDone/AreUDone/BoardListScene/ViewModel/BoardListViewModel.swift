//
//  BoardListViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import Foundation

protocol BoardListViewModelProtocol {
  
}

class BoardListViewModel: BoardListViewModelProtocol {
  
  // MARK: - Property
  
  private let boardService: BoardServiceProtocol
  
  
  // MARK: - Initializer
  
  init(boardService: BoardServiceProtocol) {
    self.boardService = boardService
  }
  
  // MARK: - Life Cycle
  
  
  // MARK: - Method
  
}
