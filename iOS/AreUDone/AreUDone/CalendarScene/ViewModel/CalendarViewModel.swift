//
//  CalendarViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/21.
//

import Foundation

protocol CalendarViewModelProtocol {
  
  func bindingUpdateCardCollectionView(handler: @escaping (Cards) -> Void)
  func bindingUpdateDate(handler: @escaping (String) -> Void)
  
  func fetchUpdateDailyCards(withOption option: FetchDailyCardsOption)
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
  
  private var updateCardCollectionViewHandler: ((Cards) -> Void)?
  private var updateDateHandler: ((String) -> Void)?
  
  private let cardService: CardServiceProtocol
  private var fetchDailyCardOption: FetchDailyCardsOption = .allCard {
    didSet {
      fetchDailyCards()
    }
  }
  private var selectedDate: Date = Date() {
    didSet {
      fetchDailyCards()
    }
  }
  
  
  // MARK:- Initializer
  
  init(cardService: CardServiceProtocol) {
    self.cardService = cardService
  }
  
  
  // MARK:- Method
  
  func changeDate(to dateAsString: String, direction: Direction?) {
    guard
      let direction = direction
    else {
      selectedDate = dateAsString.toDateAndTimeFormat()
      return
    }
    
    let date = dateAsString.toDateFormat()
    let value = direction == .left ? -1 : 1
    let calendar = Calendar(identifier: .gregorian)
    selectedDate = calendar.date(byAdding: .day, value: value, to: date)!
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
  
  func fetchUpdateDailyCards(withOption option: FetchDailyCardsOption = .allCard) {
    fetchDailyCardOption = option
  }
  
  private func fetchDailyCards() {
    cardService.fetchDailyCards(dateString: selectedDate.toString(), option: fetchDailyCardOption) { result in
      switch result {
      case .success(let cards):
        //TODO: - self가 순환참조를 일으키는 확인해야 함.
        self.updateDateHandler?(self.selectedDate.toString())
        self.updateCardCollectionViewHandler?(cards)
      case .failure(let error):
        print(error)
      }
    }
  }
}


// MARK:- Extension BindUI

extension CalendarViewModel {
  
  func bindingUpdateCardCollectionView(handler: @escaping (Cards) -> Void) {
    updateCardCollectionViewHandler = handler
  }
  
  func bindingUpdateDate(handler: @escaping (String) -> Void) {
    updateDateHandler = handler
  }
}
