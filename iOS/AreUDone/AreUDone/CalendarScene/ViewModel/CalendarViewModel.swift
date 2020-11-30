//
//  CalendarViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/21.
//

import Foundation

protocol CalendarViewModelProtocol {
  
  func bindingInitializeCardCollectionView(handler: @escaping (Cards) -> Void)
  func bindingUpdateCardCollectionView(handler: @escaping (Cards) -> Void)
  func bindingUpdateDate(handler: @escaping (String) -> Void)
  
  
  func fetchInitializeDailyCards()
  func fetchUpdateDailyCards()
  
  func initializeDate()
  func changeDate(to date: String, direction: Direction?)
}

final class CalendarViewModel: CalendarViewModelProtocol {
  
  // MARK: - Property
  
  private var initializeCardTableViewHandler: ((Cards) -> Void)?
  private var updateCardTableViewHandler: ((Cards) -> Void)?
  private var updateDateHandler: ((String) -> Void)?
  
  let cardService: CardServiceProtocol
  
  
  // MARK:- Initializer
  
  init(cardService: CardServiceProtocol) {
    self.cardService = cardService
  }
  
  
  // MARK:- Method
  
  func bindingInitializeCardCollectionView(handler: @escaping (Cards) -> Void) {
    initializeCardTableViewHandler = handler
  }
  
  func bindingUpdateCardCollectionView(handler: @escaping (Cards) -> Void) {
    updateCardTableViewHandler = handler
  }
  
  func fetchInitializeDailyCards() {
    fetchDailyCards(with: initializeCardTableViewHandler)
  }
  
  func fetchUpdateDailyCards() {
    fetchDailyCards(with: updateCardTableViewHandler)
  }
  
  func bindingUpdateDate(handler: @escaping (String) -> Void) {
    updateDateHandler = handler
  }
  
  func initializeDate() {
    let date = Date().toString()
    updateDateHandler?(date)
  }
  
  func changeDate(to date: String, direction: Direction?) {
    let date = date.toDate()
    
    if let direction = direction {
      let day = direction == .left ? -1 : 1
      let calendar = Calendar(identifier: .gregorian)
      if let updatedDate = calendar.date(byAdding: DateComponents(day: day), to: date)?.toString() {
        updateDateHandler?(updatedDate)
      }
    } else {
      updateDateHandler?(date.toString())
    }
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

