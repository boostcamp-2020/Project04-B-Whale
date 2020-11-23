//
//  CalendarViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/21.
//

import Foundation

protocol CalendarViewModelProtocol {
  func bindingInitializeCardTableView(handler: @escaping (Cards) -> Void)
  func bindingUpdateCardTableView(handler: @escaping (Cards) -> Void)
  
  func fetchInitializeDailyCards()
  func fetchUpdateDailyCards()
}

final class CalendarViewModel: CalendarViewModelProtocol {
  
  // MARK: - Property
  
  private var initializeCardTableViewHandler: ((Cards) -> Void)?
  private var updateCardTableViewHandler: ((Cards) -> Void)?
  let cardService: CardServiceProtocol
  
  
  // MARK:- Initializer
  
  init(cardService: CardServiceProtocol) {
    self.cardService = cardService
  }
  
  
  // MARK:- Method
  
  func bindingInitializeCardTableView(handler: @escaping (Cards) -> Void) {
    initializeCardTableViewHandler = handler
  }
  
  func bindingUpdateCardTableView(handler: @escaping (Cards) -> Void) {
    updateCardTableViewHandler = handler
  }
  
  func fetchInitializeDailyCards() {
    fetchDailyCards(with: initializeCardTableViewHandler)
  }
  
  func fetchUpdateDailyCards() {
    fetchDailyCards(with: updateCardTableViewHandler)
  }
  
  private func fetchDailyCards(with handler: ((Cards) -> Void)?) {
    cardService.fetchDailyCards(date: Date().toString()) { result in
      switch result {
      case .success(let cards):
        //TODO: - self가 순환참조를 일으키는 확인해야 함.
        handler?(cards)
      case .failure(let error):
        print(error)
      }
    }
  }
}

