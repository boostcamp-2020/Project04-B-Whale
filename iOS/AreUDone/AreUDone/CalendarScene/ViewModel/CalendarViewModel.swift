//
//  CalendarViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/21.
//

import Foundation

protocol CalendarViewModelProtocol {
  
}

final class CalendarViewModel: CalendarViewModelProtocol {
  
  // MARK: - Property
  let cardService: CardServiceProtocol
  
  
  init(cardService: CardServiceProtocol) {
    self.cardService = cardService
    
    cardService.fetchDailyCards(date: Date().toString()) { result in
      switch result {
      case .success(let card):
        print(card)
      case .failure(let error):
        print(error)
      }
      
    }
  }

}


