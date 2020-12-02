//
//  CardService.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/19.
//

import Foundation
import NetworkFramework

protocol CardServiceProtocol {
  func fetchDailyCards(dateString: String, completionHandler: @escaping (Result<Cards, APIError>) -> Void)
  func fetchDetailCard(id: Int, completionHandler: @escaping ((Result<CardDetail, APIError>) -> Void))
}

class CardService: CardServiceProtocol {
  
  // MARK: - Property
  
  private let router: Routable
  
  
  // MARK: - Initializer
  
  init(router: Routable) {
    self.router = router
  }
  
  
  // MARK: - Method
  
  func fetchDailyCards(dateString: String, completionHandler: @escaping (Result<Cards, APIError>) -> Void) {
    router.request(route: CardEndPoint.fetchDailyCards(dateString: dateString)) { (result: Result<Cards, APIError>) in
      completionHandler(result)
    }
  }
  
  func fetchDetailCard(id: Int, completionHandler: @escaping ((Result<CardDetail, APIError>) -> Void)) {
    router.request(route: CardEndPoint.fetchDetailCard(id: id)) { (result: Result<CardDetail, APIError>) in
      completionHandler(result)
    }
  }
  
  func updateCard() {
    
  }
}
