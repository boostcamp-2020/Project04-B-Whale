//
//  BoardDetailViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import Foundation

protocol BoardDetailViewModelProtocol {
  
  func bindingUpdateBoardDetailCollectionView(handler: @escaping () -> Void)
  func bindingUpdateBackgroundColor(handler: @escaping (String) -> Void)
  func bindingUpdateBoardTitle(handler: @escaping (String) -> Void)
    
  func numberOfLists() -> Int
  func fetchList(at index: Int, handler: ((ListViewModelProtocol) -> Void))
  func insertList(list: List)
  
  func updateBoardDetailCollectionView()
  func updateBoardTitle(to title: String)
}

final class BoardDetailViewModel: BoardDetailViewModelProtocol {
  
  // MARK: - Property
  
  private let boardService: BoardServiceProtocol
  private let listService: ListServiceProtocol
  private let cardService: CardServiceProtocol
  private let boardId: Int
  
  private var updateBoardDetailCollectionViewHandler: (() -> Void)?
  private var updateBackgroundColorHandler: ((String) -> Void)?
  private var updateBoardTitleHandler: ((String) -> Void)?
  
  private var boardDetail: BoardDetail? {
    didSet {
      updateBoardDetailCollectionViewHandler?()
    }
  }
  private var boardTitle: String = ""
  
  // MARK: - Initializer
  
  init(
    boardService: BoardServiceProtocol,
    listService: ListServiceProtocol,
    cardService: CardServiceProtocol,
    boardId: Int
  ) {
    self.boardService = boardService
    self.listService = listService
    self.cardService = cardService
    self.boardId = boardId
  }
  
  
  // MARK: - Method
  
  func numberOfLists() -> Int {
    boardDetail?.lists.count ?? 0
  }
  
  func fetchList(at index: Int, handler: ((ListViewModelProtocol) -> Void)) {
    guard let list = boardDetail?.lists[index] else { return }
    
    let viewModel = ListViewModel(listService: listService, list: list)
    handler(viewModel)
  }
  
  func insertList(list: List) {
    boardDetail?.lists.append(list)
  }
  
  func updateBoardDetailCollectionView() {
    boardService.fetchBoardDetail(with: boardId) { result in
      switch result {
      case .success(let boardDetail):
        self.boardDetail = boardDetail
        
        self.boardTitle = boardDetail.title
        self.updateBoardTitleHandler?(boardDetail.title)
        self.updateBackgroundColorHandler?(boardDetail.color)
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func updateBoardTitle(to title: String) {
    boardService.updateBoard(withBoardId: boardId, title: title) { result in
      switch result {
      case .success(()):
        self.updateBoardTitle(to: title)
        self.boardTitle = title
        
      case .failure(let error):
        self.updateBoardTitleHandler?(self.boardTitle)
        print(error)
      }
    }
  }
  
  
  
//  func updateListViewModel()
  
}


// MARK: - Extension bindUI

extension BoardDetailViewModel {
  
  func bindingUpdateBoardDetailCollectionView(handler: @escaping () -> Void) {
    updateBoardDetailCollectionViewHandler = handler
  }
  
  func bindingUpdateBackgroundColor(handler: @escaping (String) -> Void) {
    updateBackgroundColorHandler = handler
  }
  
  func bindingUpdateBoardTitle(handler: @escaping (String) -> Void) {
    updateBoardTitleHandler = handler
  }
}
