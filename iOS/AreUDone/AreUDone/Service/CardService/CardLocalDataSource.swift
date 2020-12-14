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
  func loadCards(at dateString: String) -> Cards?
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
  
  func loadCards(at dateString: String) -> Cards? {
    let result = realm.objects(Card.self).filter("dueDate CONTAINS %@", "\(dateString)")
    let loadedCard = Array(result)
    let cards = Cards()
    
    cards.cards.append(objectsIn: loadedCard)
    
    return cards
  }
}
