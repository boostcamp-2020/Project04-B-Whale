//
//  DetailCardViewModel.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/25.
//

import Foundation

protocol DetailCardViewModelProtocol {
  
}

final class DetailCardViewModel: DetailCardViewModelProtocol {
  
  // MARK:- Property
  
  private var cardService: CardServiceProtocol
  private let id: Int
  
  
  // MARK:- Initializer
  
  init(id: Int, cardService: CardServiceProtocol) {
    self.id = id
    self.cardService = cardService
  }
}
