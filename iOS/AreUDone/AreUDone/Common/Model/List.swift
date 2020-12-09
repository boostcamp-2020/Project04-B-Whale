//
//  List.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import Foundation
import MobileCoreServices

// TODO: API 연동 확인 후 삭제 예정
//struct Lists: Codable {
//  let lists: [List]
//}

class List: NSObject, Codable {
  let id: Int
  let title: String
  let position: Int
  var cards: [Card]
  
  init(id: Int, title: String, position: Int, cards: [Card]) {
    self.id = id
    self.title = title
    self.position = position
    self.cards = cards
  }
}

extension List: NSItemProviderWriting {
  static var writableTypeIdentifiersForItemProvider: [String] {
    
    return [kUTTypeData as String]
  }
  
  func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Swift.Void) -> Progress? {
    
    do {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      let data = try encoder.encode(self)
      
      completionHandler(data, nil)
      print("성공")
    } catch {
      print("에러")
      completionHandler(nil, error)
    }
    
    return nil
  }
}

extension List: NSItemProviderReading {
  static var readableTypeIdentifiersForItemProvider: [String] {
    return [kUTTypeData as String]
  }
  
  static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
    let decoder = JSONDecoder()
    do {
      let myJSON = try decoder.decode(List.self, from: data)
      return myJSON as! Self
    } catch {
      fatalError("Err")
    }
  }
}

