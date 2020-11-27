//
//  Card.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/23.
//

import Foundation
import MobileCoreServices

struct Cards: Codable {
  let cards: [Card]
}

class Card: NSObject, Codable {
  let id: Int
  let title, dueDate: String
  let position: Int?
  let commentCount: Int
  
  init(
    id: Int,
    title: String,
    dueDate: String,
    position: Int? = nil,
    commentCount: Int
  ) {
    self.id = id
    self.title = title
    self.dueDate = dueDate
    self.position = position
    self.commentCount = commentCount
  }
}

// NSObject 채택시 자동으로 Hashable 채택
// TODO: 마무리작업필요
extension Card: NSItemProviderWriting {
  public static var writableTypeIdentifiersForItemProvider: [String] {
    
          return [kUTTypePlainText as String]
      }

      public func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Swift.Void) -> Progress? {
          return nil // something here
      }
}
