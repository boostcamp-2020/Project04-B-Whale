//
//  ListViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/28.
//

import Foundation

protocol ListViewModelProtocol {
  
  func bindingUpdateListTitle(handler: @escaping (String) -> Void)
  
  func numberOfCards() -> Int
  func fetchListTitle() -> String
  func append(card: Card)
  func insert(card: Card, at index: Int)
  func fetchCard(at index: Int) -> Card
  func removeCard(at index: Int)
  
  func updateListTitle(to title: String)
  
  func makeUpdatedIndexPaths(by firstIndexPath: IndexPath, and secondIndexPath: IndexPath) -> [IndexPath]
}

final class ListViewModel: ListViewModelProtocol {
  
  // MARK: - Property
  
  private let listService: ListServiceProtocol
  
  private var updateListTitleHandler: ((String) -> Void)?
  
  private let list: List
  private var listTitle: String = ""
  
  // MARK: - Initializer
  
  init(
    listService: ListServiceProtocol,
    list: List
  ) {
    self.listService = listService
    self.list = list
    
    self.listTitle = list.title
  }
  
  
  // MARK: - Method
  
  func numberOfCards() -> Int {
    return list.cards.count
  }
  
  func fetchListTitle() -> String {
    return list.title
  }
  
  func append(card: Card) {
    list.cards.append(card)
  }
  
  func insert(card: Card, at index: Int) {
    list.cards.insert(card, at: index)
  }
  
  func fetchCard(at index: Int) -> Card {
    list.cards[index]
  }
  
  func removeCard(at index: Int) {
    guard list.cards.indices.contains(index) else { return }
    list.cards.remove(at: index)
  }
  
  func updateListTitle(to title: String) {
    listService.updateList(
      withListId: list.id,
      position: nil,
      title: title) { result in
      switch result {
      case .success(()):
        self.updateListTitleHandler?(title)
        self.listTitle = title
        
      case .failure(let error):
        self.updateListTitleHandler?(self.listTitle)
        print(error)
      }
    }
  }
}


// MARK: - Extension

extension ListViewModel {
  
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

extension ListViewModel {
  
  func bindingUpdateListTitle(handler: @escaping (String) -> Void) {
    updateListTitleHandler = handler
  }
}
