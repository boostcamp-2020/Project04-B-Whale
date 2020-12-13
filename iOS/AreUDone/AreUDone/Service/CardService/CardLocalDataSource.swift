//
//  CardLocalDataSource.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/13.
//

import Foundation
import RealmSwift

protocol CardLocalDataSourceable {
  
  func save(cards: Cards)
  func loadCards(at dateString: String) -> Cards?
}

final class CardLocalDataSource: CardLocalDataSourceable {
  
  let realm = try! Realm()
  
  func save(cards: Cards) {
    try! realm.write {
      realm.add(cards)
    }
  }
  
  
  func loadCards(at dateString: String) -> Cards? {
    let result = realm.objects(Cards.self).filter("date == '\(dateString)'")
    
    return result.first
  }
}
