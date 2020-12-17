//
//  CardService.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/19.
//

import Foundation
import NetworkFramework

protocol CardServiceProtocol {
  
  func fetchDailyCards(dateString: String, option: FetchDailyCardsOption, completionHandler: @escaping (Result<Cards, APIError>) -> Void)
  func createCard(listId: Int, title: String, dueDate: String, content: String, completionHandler: @escaping (Result<Card, APIError>) -> Void)
  func fetchDetailCard(id: Int, completionHandler: @escaping ((Result<CardDetail, APIError>) -> Void))
  func updateCard(
    id: Int,
    listId: Int?,
    title: String?,
    content: String?,
    position: Double?,
    dueDate: String?,
    completionHandler: @escaping ((Result<Void, APIError>) -> Void)
  )
  func updateCardMember(id: Int, userIds: [Int], completionHandler: @escaping ((Result<Void, APIError>) -> Void))
  func fetchCardsCount(
    startDate: String,
    endDate: String,
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
    position: Double? = nil,
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
  private let localDataSource: CardLocalDataSourceable?
  
  
  // MARK: - Initializer
  
  init(router: Routable, localDataSource: CardLocalDataSourceable? = nil) {
    self.router = router
    self.localDataSource = localDataSource
  }
  
  
  // MARK: - Method
  
  func fetchDailyCards(dateString: String, option: FetchDailyCardsOption, completionHandler: @escaping (Result<Cards, APIError>) -> Void) {
    router.request(route: CardEndPoint.fetchDailyCards(dateString: dateString, option: option)) { (result: Result<Cards, APIError>) in
      switch result {
      case .success(let cards):
        completionHandler(.success(cards))
        self.localDataSource?.save(cards: (cards.fetchCards()))
        
      case .failure(_):
        self.localDataSource?.loadCards(at: dateString, completionHandler: { cards in
          guard let cards = cards else {
            completionHandler(.failure(.data))
            return
          }
          completionHandler(.success(cards))
        })
      }
    }
  }
  
  func createCard(listId: Int, title: String, dueDate: String, content: String, completionHandler: @escaping (Result<Card, APIError>) -> Void) {
    let endPoint = CardEndPoint.createCard(listId: listId, title: title, dueDate: dueDate, content: content)
    router.request(route: endPoint) { (result: Result<Card, APIError>) in
      DispatchQueue.main.async {
        
        switch result {
        case .success(_):
          completionHandler(result)
          
        case .failure(_):
          
          if let localDataSource = self.localDataSource {
            let storedEndPoint = StoredEndPoint(value: endPoint.toDictionary())
            localDataSource.save(with: listId, storedEndPoint: storedEndPoint) { card in
              completionHandler(.success(card))
            }
          }
        }
      }
    }
  }


func fetchDetailCard(id: Int, completionHandler: @escaping ((Result<CardDetail, APIError>) -> Void)) {
  router.request(route: CardEndPoint.fetchDetailCard(id: id)) { (result: Result<CardDetail, APIError>) in
    switch result {
    case .success(let cardDetail):
      completionHandler(.success(cardDetail))
      self.localDataSource?.save(cardDetail: cardDetail)
      
    case .failure(_):
      self.localDataSource?.loadCardDetail(for: id, completionHandler: { cardDetail in
        guard let cardDetail = cardDetail else {
          completionHandler(.failure(.data))
          return
        }
        completionHandler(.success(cardDetail))
      })
    }
  }
}

func updateCard(
  id: Int,
  listId: Int? = nil,
  title: String? = nil,
  content: String? = nil,
  position: Double? = nil,
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
    switch result {
    case .success(()):
      completionHandler(result)
      self.localDataSource?.updateCardDetail(for: id, content: content, dueDate: dueDate)
      
    case .failure(_):
      completionHandler(.failure(.data))
    }
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
  completionHandler: @escaping ((Result<MonthCardCount, APIError>) -> Void)
) {
  router.request(route: CardEndPoint.fetchCardsCount(
    startDate: startDate,
    endDate: endDate
  )) { (result: Result<MonthCardCount, APIError>) in
    completionHandler(result)
  }
}

func deleteCard(for cardId: Int, completionHandler: @escaping ((Result<Void, APIError>) -> Void)) {
  router.request(route: CardEndPoint.deleteCard(id: cardId)) { (result: Result<Void, APIError>) in
    switch result {
    case .success(()):
      completionHandler(.success(()))
      self.localDataSource?.deleteCard(for: cardId)
      
    case .failure(_):
      completionHandler(.failure(.data))
    }
  }
}
}
