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
  func bindingUpdateControlPageCounts(handler: @escaping (Int) -> Void)
  
  func numberOfLists() -> Int
  func fetchList(at index: Int) -> List?
  func remove(at index: Int)
  func insert(list: List, at index: Int)
  
  func fetchListViewModel(at index: Int, handler: ((ListViewModelProtocol) -> Void))

  func updateBoardDetailCollectionView()
  func updateBoardTitle(to title: String)
  func updatePosition(of sourceIndex: Int, to destinationIndex: Int)
  
  func createList(with title: String)
  
  func makeUpdatedIndexPaths(by firstIndexPath: IndexPath, and secondIndexPath: IndexPath) -> [IndexPath]

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
  private var updateControlPageCountsHandler: ((Int) -> Void)?
  
  private var boardDetail: BoardDetail? {
    didSet {
      self.updateBoardDetailCollectionViewHandler?()
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
  
  func remove(at index: Int) {
    guard let lists = boardDetail?.lists,
          lists.indices.contains(index) else { return }
    boardDetail?.lists.remove(at: index)
  }
  
  func insert(list: List, at index: Int) {
    boardDetail?.lists.insert(list, at: index)
  }
  
  func fetchListViewModel(at index: Int, handler: ((ListViewModelProtocol) -> Void)) {
    guard let list = boardDetail?.lists[index] else { return }
    
    let viewModel = ListViewModel(
      listService: listService,
      cardService: cardService,
      list: list
    )
    handler(viewModel)
  }
  
  func fetchList(at index: Int) -> List? {
    return boardDetail?.lists[index]
  }

  func updateBoardDetailCollectionView() {
    boardService.fetchBoardDetail(with: boardId) { result in
      switch result {
      case .success(let boardDetail):
        self.boardDetail = boardDetail
        
        self.boardTitle = boardDetail.title
        self.updateBoardTitleHandler?(boardDetail.title)
        self.updateBackgroundColorHandler?(boardDetail.color)
        self.updateControlPageCountsHandler?(boardDetail.lists.count)

      case .failure(let error):
        print(error)
      }
    }
  }
  
  func updateBoardTitle(to title: String) {
    boardService.updateBoard(withBoardId: boardId, title: title) { result in
      switch result {
      case .success(()):
        self.updateBoardTitleHandler?(title)
        self.boardTitle = title
        
      case .failure(let error):
        self.updateBoardTitleHandler?(self.boardTitle)
        print(error)
      }
    }
  }
  
  func updatePosition(of sourceIndex: Int, to destinationIndex: Int) {
    guard let lists = boardDetail?.lists else { return }
    
    // TODO: API 연동 후 수정 예정

    let listId = lists[sourceIndex].id
    
    var position: Double
    if lists.count != (destinationIndex+1) {
      position = (lists[destinationIndex-1].position + lists[destinationIndex].position) / 2
    } else {
      // 맨 마지막에 넣는 경우 (다음에 올 수 있는 position 값 구함)
      position = (lists[destinationIndex].position + floor((lists[destinationIndex].position) + 1)) / 2
    }
        
    listService.updateList(withListId: listId, position: position, title: nil) { result in
      switch result {
      case .success(()):
        break

      case .failure(let error):
        print(error)
      }
    }
  }
  
  func createList(with title: String) {
    listService.createList(withBoardId: boardId, title: title) { result in
      switch result {
      case .success(()):
        self.updateBoardDetailCollectionView()
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func makeUpdatedIndexPaths(by firstIndexPath: IndexPath, and secondIndexPath: IndexPath) -> [IndexPath] {
    var updatedIndexPaths: [IndexPath]
    
    if firstIndexPath.item < secondIndexPath.item {
      updatedIndexPaths =
        (firstIndexPath.item...secondIndexPath.item)
        .map { IndexPath(row: $0, section: 0) }
      
    } else if firstIndexPath.item > secondIndexPath.item {
      updatedIndexPaths =
        (secondIndexPath.item...firstIndexPath.item)
        .map { IndexPath(row: $0, section: 0) }
      
    } else {
      updatedIndexPaths = []
    }
    
    return updatedIndexPaths
  }
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
  
  func bindingUpdateControlPageCounts(handler: @escaping (Int) -> Void) {
    updateControlPageCountsHandler = handler
  }
}
