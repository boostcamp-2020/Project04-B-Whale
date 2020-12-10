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
  func updateCard(
    id: Int,
    listId: Int?,
    title: String?,
    content: String?,
    position: String?,
    dueDate: String?,
    completionHandler: @escaping ((Result<Void, APIError>) -> Void)
  )
  func updateCardMember(id: Int, userIds: [Int], completionHandler: @escaping ((Result<Void, APIError>) -> Void))
  func fetchCardsCount(
    startDate: String,
    endDate: String,
    member: String?,
    completionHandler: @escaping ((Result<MonthCardCount, APIError>) -> Void)
  )
  func deleteCard(for cardId: Int, completionHandler: @escaping ((Result<Void, APIError>) -> Void))
}

extension CardServiceProtocol {
  func updateCard(
    id: Int,
    listId: Int? = nil,
    title: String? = nil,
    content: String? = nil,
    position: String? = nil,
    dueDate: String? = nil,
    completionHandler: @escaping ((Result<Void, APIError>) -> Void)
  ) {
    updateCard(
      id: id,
      listId: listId,
      title: title,
      content: content,
      position: position,
      dueDate: dueDate,
      completionHandler: completionHandler
    )
  }
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
  
  func updateCard(
    id: Int,
    listId: Int? = nil,
    title: String? = nil,
    content: String? = nil,
    position: String? = nil,
    dueDate: String? = nil,
    completionHandler: @escaping ((Result<Void, APIError>) -> Void)
  ) {
    router.request(route: CardEndPoint.updateCard(
      id: id,
      listId: listId,
      title: title,
      content: content,
      position: position,
      dueDate: dueDate
    )) { (result: Result<Void, APIError>) in
      completionHandler(result)
    }
  }
  
  func updateCardMember(id: Int, userIds: [Int], completionHandler: @escaping ((Result<Void, APIError>) -> Void)) {
    router.request(route: CardEndPoint.updateCardMember(id: id, userIds: userIds)) { (result: Result<Void, APIError>) in
      completionHandler(result)
    }
  }
  
  func fetchCardsCount(
    startDate: String,
    endDate: String,
    member: String?,
    completionHandler: @escaping ((Result<MonthCardCount, APIError>) -> Void)
  ) {
    router.request(route: CardEndPoint.fetchCardsCount(
      startDate: startDate,
      endDate: endDate,
      member: member
    )) { (result: Result<MonthCardCount, APIError>) in
      completionHandler(result)
    }
  }
  
  func deleteCard(for cardId: Int, completionHandler: @escaping ((Result<Void, APIError>) -> Void)) {
    router.request(route: CardEndPoint.deleteCard(id: cardId)) { (result: Result<Void, APIError>) in
      completionHandler(result)
    }
  }
}
