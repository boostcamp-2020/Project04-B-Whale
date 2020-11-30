//
//  ListViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/28.
//

import Foundation

protocol ListViewModelProtocol {
  
  func numberOfCards() -> Int
  
  func append(card: List.Card)
  func insert(card: List.Card, at index: Int)
  func fetchCard(at index: Int) -> List.Card
  func removeCard(at index: Int)
  
  func makeUpdatedIndexPaths(by firstIndexPath: IndexPath, and secondIndexPath: IndexPath) -> [IndexPath]
}

final class ListViewModel: ListViewModelProtocol {
  
  // MARK: - Property
  
  private let list: List
  
  
  // MARK: - Initializer
  
  init(list: List) {
    self.list = list
  }
  
  
  // MARK: - Method
  
  func numberOfCards() -> Int {
    list.cards.count
  }
  
  func append(card: List.Card) {
    list.cards.append(card)
  }
  
  func insert(card: List.Card, at index: Int) {
    list.cards.insert(card, at: index)
  }
  
  func fetchCard(at index: Int) -> List.Card {
    list.cards[index]
  }
  
  func removeCard(at index: Int) {
    guard list.cards.indices.contains(index) else { return }
    list.cards.remove(at: index)
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
