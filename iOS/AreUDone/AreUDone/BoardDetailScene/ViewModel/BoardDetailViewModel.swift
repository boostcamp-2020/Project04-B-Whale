//
//  BoardDetailViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import Foundation

protocol BoardDetailViewModelProtocol {
  
  func bindingUpdateBoardDetailCollectionView(handler: @escaping () -> Void)
  
  func updateBoardDetailCollectionView()
  
  func numberOfLists() -> Int
  func fetchList(at index: Int) -> List?
  func insertList(list: List)
}

final class BoardDetailViewModel: BoardDetailViewModelProtocol {
  
  // MARK: - Property
  
  private let boardService: BoardServiceProtocol
  private let boardId: Int
  
  private var updateBoardDetailCollectionViewHandler: (() -> Void)?
  
  private var boardDetail: BoardDetail? {
    didSet {
      updateBoardDetailCollectionViewHandler?()
    }
  }

  // MARK: - Initializer
  
  init(boardService: BoardServiceProtocol, boardId: Int) {
    self.boardService = boardService
    self.boardId = boardId
  }
  
  
  // MARK: - Method
  
  func numberOfLists() -> Int {
    boardDetail?.lists.count ?? 0
  }
  
  func fetchList(at index: Int) -> List? {
    boardDetail?.lists[index]
  }
  
  func insertList(list: List) {
    boardDetail?.lists.append(list)
  }
  
  func updateBoardDetailCollectionView() {
    boardService.fetchBoardDetail(with: boardId) { result in
      switch result {
      case .success(let boardDetail):
        self.boardDetail = boardDetail
      case .failure(let error):
        print(error)
      }
    }
  }
}


// MARK: - Extension bindUI

extension BoardDetailViewModel {
  
  func bindingUpdateBoardDetailCollectionView(handler: @escaping () -> Void) {
    updateBoardDetailCollectionViewHandler = handler
  }
}
