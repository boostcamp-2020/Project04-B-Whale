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
  func fetchUpdateDailyCards(withOption option: FetchDailyCardsOption)
  
  func initializeDate()
  func changeDate(to date: String, direction: Direction?)
  func deleteCard(for cardId: Int, completionHandler: @escaping () -> Void)
}

extension CalendarViewModelProtocol {
  
  func fetchUpdateDailyCards(withOption option: FetchDailyCardsOption = .allCard) {
    fetchUpdateDailyCards(withOption: option)
  }
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
  
  func initializeDate() {
    let date = Date().toString()
    updateDateHandler?(date)
  }
  
  func changeDate(to dateAsString: String, direction: Direction?) {
    guard
      let direction = direction
    else {
      let date = dateAsString.toDateAndTimeFormat()
      updateDateHandler?(date.toString())
      return
    }
    
    let date = dateAsString.toDateFormat(withDividerFormat: .dash)
    let value = direction == .left ? -1 : 1
    let calendar = Calendar(identifier: .gregorian)
    if let updatedDate = calendar.date(byAdding: .day, value: value, to: date)?.toString() {
      updateDateHandler?(updatedDate)
    }
  }
  
  func deleteCard(for cardId: Int, completionHandler: @escaping () -> Void) {
    cardService.deleteCard(for: cardId) { result in
      switch result {
      case .success(()):
        completionHandler()
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func fetchInitializeDailyCards() {
    fetchDailyCards(with: initializeCardTableViewHandler)
  }
  
  func fetchUpdateDailyCards(withOption option: FetchDailyCardsOption = .allCard) {
    fetchDailyCards(with: updateCardTableViewHandler, option: option)
  }
  
  private func fetchDailyCards(with handler: ((Cards) -> Void)?, option: FetchDailyCardsOption = .allCard) {
    cardService.fetchDailyCards(dateString: Date().toString(), option: option) { result in
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


// MARK:- Extension BindUI

extension CalendarViewModel {
  
  func bindingInitializeCardCollectionView(handler: @escaping (Cards) -> Void) {
    initializeCardTableViewHandler = handler
  }
  
  func bindingUpdateCardCollectionView(handler: @escaping (Cards) -> Void) {
    updateCardTableViewHandler = handler
  }
  
  func bindingUpdateDate(handler: @escaping (String) -> Void) {
    updateDateHandler = handler
  }
}
