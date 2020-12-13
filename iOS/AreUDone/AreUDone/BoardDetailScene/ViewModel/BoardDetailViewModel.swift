//
//  BoardDetailViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import Foundation
import RealmSwift

protocol BoardDetailViewModelProtocol {
  
  func bindingUpdateBoardDetailCollectionView(handler: @escaping () -> Void)
  func bindingUpdateBackgroundColor(handler: @escaping (String) -> Void)
  func bindingUpdateBoardTitle(handler: @escaping (String) -> Void)
  func bindingUpdateControlPageCounts(handler: @escaping (Int) -> Void)
  
  func numberOfLists() -> Int
  func fetchList(at index: Int) -> ListOfBoard?
  func remove(at index: Int)
  func insert(list: ListOfBoard, at index: Int)
  
  func fetchListViewModel(at index: Int, handler: ((ListViewModelProtocol) -> Void))

  func fetchBoardDetail()
  func updateBoardTitle(to title: String)
  func updatePosition(of sourceIndex: Int, to destinationIndex: Int, list: ListOfBoard, handler: @escaping () -> Void)

  func createList(with title: String)
}

final class BoardDetailViewModel: BoardDetailViewModelProtocol {
  
  // MARK: - Property
  
  let realm = try! Realm()

  
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
  private var boardTitle: String = "" {
    didSet {
      DispatchQueue.main.async {
        try! self.realm.write {
          self.boardDetail?.title = self.boardTitle
        }
      }
      

      updateBoardTitleHandler?(boardTitle)
    }
  }
  
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
    return boardDetail?.lists.count ?? 0
  }
  
  func remove(at index: Int) {
    guard let lists = boardDetail?.lists,
          lists.indices.contains(index) else { return }
    boardDetail?.lists.remove(at: index)
  }
  
  func insert(list: ListOfBoard, at index: Int) {
    boardDetail?.lists.insert(list, at: index)
  }
  
  func fetchListViewModel(at index: Int, handler: ((ListViewModelProtocol) -> Void)) {
    guard let list = boardDetail?.lists[index] else { return }
    
    let viewModel = ListViewModel(
      listService: listService,
      cardService: cardService,
      boardId: boardId,
      list: list
    )
    handler(viewModel)
  }
  
  func fetchList(at index: Int) -> ListOfBoard? {
    return boardDetail?.lists[index]
  }

  func fetchBoardDetail() {
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
        self.boardTitle = title
        
      case .failure(let error):
        self.updateBoardTitleHandler?(self.boardTitle)

        print(error)
      }
    }
  }
  
  func updatePosition(of sourceIndex: Int, to destinationIndex: Int, list: ListOfBoard, handler: @escaping () -> Void) {
    guard let lists = boardDetail?.lists else { return }
    
    let listId = lists[sourceIndex].id
    
    var position: Double
    if destinationIndex == 0 {
      // 맨 앞에 넣는 경우
      position = lists[destinationIndex].position / 2
    } else if destinationIndex == (lists.count-1) {
      // 맨 마지막에 넣는 경우
      position = lists[destinationIndex].position + 1
    } else if sourceIndex < destinationIndex {
      position = (lists[destinationIndex].position + lists[destinationIndex+1].position) / 2
    } else {
      position = (lists[destinationIndex-1].position + lists[destinationIndex].position) / 2
    }
    
    listService.updateList(withBoardId: boardId, listId: listId, position: position, title: nil) { result in
      switch result {
      case .success(_):
        
        self.remove(at: sourceIndex)
        list.position = position
        self.insert(list: list, at: destinationIndex)
        
        handler()

      case .failure(let error):
        print(error)
      }
    }
  }
  
  func createList(with title: String) {
    listService.createList(withBoardId: boardId, title: title) { result in
      switch result {
      case .success(let list):
        self.realm.writeOnMain {
          self.boardDetail?.lists.append(list)
        }
        self.updateBoardDetailCollectionViewHandler?()
        
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
