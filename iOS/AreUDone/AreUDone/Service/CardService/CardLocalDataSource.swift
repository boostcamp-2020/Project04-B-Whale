//
//  CardLocalDataSource.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/13.
//

import Foundation
import RealmSwift

protocol CardLocalDataSourceable {
  
  func save(cards: [Card])
  func save(cardDetail: CardDetail)
  
  func updateCardDetail(for id: Int, content: String?, dueDate: String?)
  
  func loadCards(at dateString: String) -> Cards?
  func loadCardDetail(for cardId: Int) -> CardDetail?
}

final class CardLocalDataSource: CardLocalDataSourceable {
  
  let realm = try! Realm()
  
  func save(cards: [Card]) {
    try! realm.write {
      cards.forEach {
        realm.add($0, update: .all)
      }
    }
  }
  
  func save(cardDetail: CardDetail) {
    do {
      try realm.write {
        realm.add(cardDetail, update: .all)
      }
    } catch {
      
    }
  }
  
  func updateCardDetail(for id: Int, content: String?, dueDate: String?) {
    do {
      guard let cardDetail = realm.objects(CardDetail.self).filter("id == \(id)").first else { return }
      guard let card = realm.objects(Card.self).filter("id == \(id)").first else { return }
      try realm.write {
        if let content = content {
          cardDetail.content = content
        }
        
        if let dueDate = dueDate {
          card.dueDate = dueDate
          cardDetail.dueDate = dueDate
        }
      }
    } catch {
      
    }
  }
  
  func loadCards(at dateString: String) -> Cards? {
    let result = realm.objects(Card.self).filter("dueDate CONTAINS %@", "\(dateString)")
    let loadedCard = Array(result)
    let cards = Cards()
    
    cards.cards.append(objectsIn: loadedCard)
    
    return cards
  }
  
  func loadCardDetail(for cardId: Int) -> CardDetail? {
    let result = realm.objects(CardDetail.self).filter("id == \(cardId)")
    
    return result.first
  }
}
