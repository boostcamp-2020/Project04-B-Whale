//
//  CommentLocalDataSource.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/16.
//

import Foundation
import RealmSwift

protocol CommentLocalDataSourceable {
  
  func save(comment: CardDetailComment, forCardId cardId: Int)
  func deleteComment(for id: Int)
}

final class CommentLocalDataSource: CommentLocalDataSourceable {
  
  // MARK: - Property
  
  let realm = try! Realm()
  
  
  // MARK: - Method
  
  func save(comment: CardDetailComment, forCardId cardId: Int) {
    realm.writeOnMain {
      guard let cardDetail = self.realm.objects(CardDetail.self).filter("id == \(cardId)").first else { return }
      
      cardDetail.comments.append(comment)
    }
  }
  
  func deleteComment(for id: Int) {
    realm.writeOnMain {
      guard let comment = self.realm.objects(CardDetailComment.self).filter("id == \(id)").first else { return }
      
      self.realm.delete(comment)
    }
  }
}
