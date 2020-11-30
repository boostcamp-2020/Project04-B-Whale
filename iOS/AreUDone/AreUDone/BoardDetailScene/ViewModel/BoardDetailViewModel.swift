//
//  BoardDetailViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import Foundation

protocol BoardDetailViewModelProtocol {
  
  func numberOfLists() -> Int
  func fetchList(at index: Int) -> List
  func insertList(list: List)
}

final class BoardDetailViewModel: BoardDetailViewModelProtocol {
  
  // MARK: - Property
  
  private let boardService: BoardServiceProtocol
  
  let cards = [
    List.Card(id: 1, title: "카드1", dueDate: "날짜1", position: 0, commentCount: 0),
    List.Card(id: 2, title: "카드2", dueDate: "날짜", position: 0, commentCount: 0)
  ]
  
  let cards2 = [
    List.Card(id: 3, title: "카드3", dueDate: "날짜1", position: 0, commentCount: 0),
    List.Card(id: 4, title: "카드4", dueDate: "날짜", position: 0, commentCount: 0)
  ]
  
  let cards3 = [
    List.Card(id: 5, title: "카드3", dueDate: "날짜1", position: 0, commentCount: 0),
    List.Card(id: 6, title: "카드4", dueDate: "날짜", position: 0, commentCount: 0),
    List.Card(id: 5, title: "카드3", dueDate: "날짜1", position: 0, commentCount: 0),
    List.Card(id: 6, title: "카드4", dueDate: "날짜", position: 0, commentCount: 0),
    List.Card(id: 5, title: "카드3", dueDate: "날짜1", position: 0, commentCount: 0),
    List.Card(id: 6, title: "카드4", dueDate: "날짜", position: 0, commentCount: 0),
    List.Card(id: 5, title: "카드3", dueDate: "날짜1", position: 0, commentCount: 0),
    List.Card(id: 6, title: "카드4", dueDate: "날짜", position: 0, commentCount: 0),
    List.Card(id: 6, title: "카드4", dueDate: "날짜", position: 0, commentCount: 0),
    List.Card(id: 5, title: "카드3", dueDate: "날짜1", position: 0, commentCount: 0),
    List.Card(id: 6, title: "카드4", dueDate: "날짜", position: 0, commentCount: 0),
    List.Card(id: 6, title: "카드4", dueDate: "날짜", position: 0, commentCount: 0),
    List.Card(id: 5, title: "카드3", dueDate: "날짜1", position: 0, commentCount: 0),
    List.Card(id: 6, title: "카드4", dueDate: "날짜", position: 0, commentCount: 0)
  ]
  
  lazy var lists = [
    List(id: 0, title: "데이터1", position: 0, cards: cards),
    List(id: 1, title: "데이터2", position: 0, cards: cards2),
    List(id: 2, title: "데이터3", position: 0, cards: cards3),
    List(id: 3, title: "데이터4", position: 0, cards: [])
  ]
  
  // MARK: - Initializer
  
  init(boardService: BoardServiceProtocol) {
    self.boardService = boardService
  }
  
  
  // MARK: - Method
  
  func numberOfLists() -> Int {
    lists.count
  }
  
  func fetchList(at index: Int) -> List {
    lists[index]
  }
  
  func insertList(list: List) {
    lists.append(list)
  }
}

extension BoardDetailViewModel {
  
  
}
