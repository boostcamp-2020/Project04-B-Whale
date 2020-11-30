//
//  CardService.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/19.
//

import Foundation
import NetworkFramework

protocol CardServiceProtocol {
  func fetchDailyCards(date: String, completionHandler: @escaping (Result<Cards, APIError>) -> Void)
}

class CardService: CardServiceProtocol {
  
  // MARK: - Property
  
  private let router: Routable
  
  
  // MARK: - Initializer
  
  init(router: Routable) {
    self.router = router
  }
  
  
  // MARK: - Method
  
  func fetchDailyCards(date: String, completionHandler: @escaping (Result<Cards, APIError>) -> Void) {
    router.request(route: CardEndPoint.fetchDailyCards(date: date)) { (result: Result<Cards, APIError>) in
      completionHandler(result)
    }
  }
}