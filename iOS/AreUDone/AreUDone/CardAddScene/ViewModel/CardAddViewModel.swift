//
//  CardAddViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/10.
//

import Foundation

protocol CardAddViewModelProtocol {
  
}

final class CardAddViewModel: CardAddViewModelProtocol {
  
  // MARK: - Property
  
  private let cardService: CardServiceProtocol
  
  
  // MARK: - Initializer
  
  init(cardService: CardServiceProtocol) {
    self.cardService = cardService
  }
  
  
  // MARK: - Method
  
}


// MARK: - Extension

private extension CardAddViewModel {
  
}

// MARK: - Extension UIBind

extension CardAddViewModel {
  
}

