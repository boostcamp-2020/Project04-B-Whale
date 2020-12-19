//
//  ListViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/28.
//

import Foundation
import RealmSwift

protocol ListViewModelProtocol {
  
  func bindingUpdateCollectionView(handler: @escaping () -> Void)
  func bindingUpdateListTitle(handler: @escaping (String) -> Void)
  
  func fetchListId() -> Int
  func fetchListTitle() -> String
  
  func numberOfCards() -> Int
  func append(card: Card)
  func insert(card: Card, at index: Int)
  func fetchCard(at index: Int) -> Card
  func removeCard(at index: Int)
  
  func updateListTitle(to title: String)
  
  func updateCardPosition(from sourceIndex: Int, to destinationIndex: Int, by card: Card, handler: @escaping () -> Void)
  func updateCardPosition(from sourceIndex: Int, to destinationIndex: Int, by card: Card, in sourceViewModel: ListViewModelProtocol, handler: @escaping () -> Void)
  func updateCardPosition(from sourceIndex: Int, by card: Card, in sourceViewModel: ListViewModelProtocol, handler: @escaping (Int) -> Void)
  
  func updateTableView()
}

final class ListViewModel: ListViewModelProtocol {
  
  // MARK: - Property
  
  let realm = try! Realm()
  
  
  private let listService: ListServiceProtocol
  private let cardService: CardServiceProtocol
  private let boardId: Int
  
  private var updateListTitleHandler: ((String) -> Void)?
  private var updateCollectionViewHandler: (() -> Void)?
  
  private let list: ListOfBoard
  private var listTitle: String = "" {
    didSet {
      realm.writeOnMain {
        self.list.title = self.listTitle
      }
      
      updateListTitleHandler?(listTitle)
    }
  }
  
  
  // MARK: - Initializer
  
  init(
    listService: ListServiceProtocol,
    cardService: CardServiceProtocol,
    boardId: Int,
    list: ListOfBoard
  ) {
    self.listService = listService
    self.cardService = cardService
    self.boardId = boardId
    self.list = list
    
    self.listTitle = list.title
  }
  
  
  // MARK: - Method
  
  func numberOfCards() -> Int {
    return list.cards.count

  }
  
  func fetchListId() -> Int {
    return list.id
  }
  
  func fetchListTitle() -> String {
    return list.title
  }
  
  func append(card: Card) {
    self.list.cards.append(card)
  }
  
  func insert(card: Card, at index: Int) {
    list.cards.insert(card, at: index)
  }
  
  func fetchCard(at index: Int) -> Card {
    return list.cards[index]
  }
  
  func removeCard(at index: Int) {
    guard list.cards.indices.contains(index) else { return }
    self.list.cards.remove(at: index)
  }
  
  func updateListTitle(to title: String) {
    let trimmedTitle = title.trimmed
    
    listService.updateList(
      ofId: list.id,
      position: nil,
      title: trimmedTitle
    ) { result in
      switch result {
      case .success(()):
        self.listTitle = trimmedTitle
        
      case .failure(let error):
        self.updateListTitleHandler?(self.listTitle)
        print(error)
      }
    }
  }
  
  func updateCardPosition(
    from sourceIndex: Int,
    to destinationIndex: Int,
    by card: Card,
    handler: @escaping () -> Void
  ) {
    var position: Double
    if destinationIndex == 0 {
      // 맨 앞에 넣는 경우
      position = list.cards[destinationIndex].position / 2
    } else if destinationIndex == (list.cards.count-1) {
      // 맨 마지막에 넣는 경우
      position = list.cards[destinationIndex].position + 1
    } else if sourceIndex < destinationIndex {
      position = (list.cards[destinationIndex].position + list.cards[destinationIndex+1].position) / 2
    } else {
      position = (list.cards[destinationIndex-1].position + list.cards[destinationIndex].position) / 2
    }
    
    cardService.updateCard(
      id: card.id,
      listId: fetchListId(),
      position: position
    ) { result in
      switch result {
      case .success(_):
        self.realm.writeOnMain {
          self.removeCard(at: sourceIndex)
          card.position = position
          self.insert(card: card, at: destinationIndex)
          
          handler()
        }
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func updateCardPosition(
    from sourceIndex: Int,
    to destinationIndex: Int,
    by card: Card,
    in sourceViewModel: ListViewModelProtocol,
    handler: @escaping () -> Void
  ) {
    var position: Double
    if destinationIndex == 0 {
      // 맨 앞에 넣는 경우
      if list.cards.isEmpty { position = 1 }
      else { position = list.cards[destinationIndex].position / 2 }
    } else if destinationIndex == (list.cards.count) {
      // 맨 마지막에 넣는 경우
      position = list.cards[destinationIndex-1].position + 1
    } else {
      position = (list.cards[destinationIndex-1].position + list.cards[destinationIndex].position) / 2
    }
    
    cardService.updateCard(
      id: card.id,
      listId: fetchListId(),
      position: position
    ) { result in
      switch result {
      case .success(_):
        self.realm.writeOnMain {
          sourceViewModel.removeCard(at: sourceIndex)
          card.position = position
          self.insert(card: card, at: destinationIndex)

          handler()
        }
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func updateCardPosition(
    from sourceIndex: Int,
    by card: Card,
    in sourceViewModel: ListViewModelProtocol,
    handler: @escaping (Int) -> Void
  ) {
    var position: Double
    if list.cards.isEmpty {
      position = 1
    } else {
      position = (list.cards.last?.position ?? 0) + 1
    }
    
    cardService.updateCard(
      id: card.id,
      listId: fetchListId(),
      position: position
    ) { result in
      switch result {
      case .success(_):
        self.realm.writeOnMain {
          sourceViewModel.removeCard(at: sourceIndex)
          card.position = position
          self.append(card: card)
          
          let lastIndex = self.numberOfCards() - 1
          handler(lastIndex)
        }
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func updateTableView() {
    updateCollectionViewHandler?()
  }
}


// MARK: - Extension bindUI

extension ListViewModel {
  
  func bindingUpdateCollectionView(handler: @escaping () -> Void) {
    updateCollectionViewHandler = handler
  }
  
  func bindingUpdateListTitle(handler: @escaping (String) -> Void) {
    updateListTitleHandler = handler
  }
}
