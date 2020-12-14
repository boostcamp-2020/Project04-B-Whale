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
  
//  func loadCards(at dateString: String) -> Cards?
  func loadCards(at dateString: String, completionHandler: @escaping ((Cards?) -> Void))
  func loadCardDetail(for cardId: Int) -> CardDetail?
  
  func deleteCard(for cardId: Int)
}

final class CardLocalDataSource: CardLocalDataSourceable {
  
  let realm = try! Realm()
  
  func save(cards: [Card]) {
    realm.writeOnMain {
      cards.forEach {
        self.realm.add($0, update: .all)
      }
    }
  }
  
  func save(cardDetail: CardDetail) {
    
    realm.writeOnMain {
      self.realm.add(cardDetail, update: .all)
    }
    
  }
  
  func updateCardDetail(for id: Int, content: String?, dueDate: String?) {
    realm.writeOnMain {
      guard let cardDetail = self.realm.objects(CardDetail.self).filter("id == \(id)").first else { return }
      guard let card = self.realm.objects(Card.self).filter("id == \(id)").first else { return }
      if let content = content {
        cardDetail.content = content
      }
      
      if let dueDate = dueDate {
        card.dueDate = dueDate
        cardDetail.dueDate = dueDate
      }
    }
    
  }
  
  func loadCards(at dateString: String, completionHandler: @escaping ((Cards?) -> Void)) {
    realm.writeOnMain {
      let result = self.realm.objects(Card.self).filter("dueDate CONTAINS %@", "\(dateString)")
      let loadedCard = Array(result)
      if loadedCard.isEmpty {
        completionHandler(nil)
      } else {
        let cards = Cards()
        
        cards.cards.append(objectsIn: loadedCard)
        completionHandler(cards)
      }
    }
  }
  
  func loadCardDetail(for cardId: Int) -> CardDetail? {
    let result = realm.objects(CardDetail.self).filter("id == \(cardId)")
    
    return result.first
  }
  
  func deleteCard(for cardId: Int) {
    let card = realm.objects(Card.self).filter("id == \(cardId)")
    realm.writeOnMain {
      self.realm.delete(card)
    }
  }
}
