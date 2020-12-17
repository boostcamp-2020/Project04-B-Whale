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
  func save(
    with listId: Int,
    storedEndPoint: StoredEndPoint,
    handler: @escaping (Card) -> Void
  )
  
  func updateCardDetail(for id: Int, content: String?, dueDate: String?)
  
  func loadCards(at dateString: String, completionHandler: @escaping ((Cards?) -> Void))
  func loadCardDetail(for cardId: Int, completionHandler: @escaping ((CardDetail?) -> Void))
  
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
  
  func save(
    with listId: Int,
    storedEndPoint: StoredEndPoint,
    handler: @escaping (Card) -> Void
  ) {
    realm.writeOnMain(object: storedEndPoint) { object in
      // 1. EndPoint 저장하고
      self.realm.create(StoredEndPoint.self, value: object)


      // title, duedate, comment count
      // 2. 로컬로 미리 반영
      if let list =
          self.realm.objects(ListOfBoard.self)
          .filter("id == \(listId)").first
      {
        let object = Card(value: storedEndPoint.bodies as Any)
//        list.cards.append(object)

        // 3. unmanaged object 로 반환
        handler(Card(value: object))
      }
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
  
  func loadCardDetail(for cardId: Int, completionHandler: @escaping ((CardDetail?) -> Void)) {
    realm.writeOnMain {
      let result = self.realm.objects(CardDetail.self).filter("id == \(cardId)")
      
      completionHandler(result.first)
    }
  }
  
  func deleteCard(for cardId: Int) {
    realm.writeOnMain {
      let card = self.realm.objects(Card.self).filter("id == \(cardId)")
      self.realm.delete(card)
    }
  }
}
