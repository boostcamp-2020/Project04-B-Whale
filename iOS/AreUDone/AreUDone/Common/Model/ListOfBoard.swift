//
//  List.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import Foundation
import MobileCoreServices
import RealmSwift

class ListOfBoard: Object, Codable {
  @objc dynamic var id: Int = 0
  @objc dynamic var title: String = ""
  @objc dynamic var position: Double = 0.0
  var cards = List<Card>()
//
//  init(id: Int, title: String, position: Double, cards: [Card]) {
//    self.id = id
//    self.title = title
//    self.position = position
//    self.cards = cards
//  }
//
  required convenience init(from decoder: Decoder) throws {
    self.init()
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(Int.self, forKey: .id)
    self.title = try container.decode(String.self, forKey: .title)
    self.position = try container.decodeIfPresent(Double.self, forKey: .position) ?? 0
//    self.cards = try container.decodeIfPresent([Card].self, forKey: .cards) ?? []
    
    let decodedCards =
      try container.decodeIfPresent([Card].self, forKey: .cards) ?? [Card()]
    cards.append(objectsIn: decodedCards)
    
  }
}

extension ListOfBoard: NSItemProviderWriting {
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

extension ListOfBoard: NSItemProviderReading {
  static var readableTypeIdentifiersForItemProvider: [String] {
    return [kUTTypeData as String]
  }
  
  static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
    let decoder = JSONDecoder()
    do {
      let myJSON = try decoder.decode(ListOfBoard.self, from: data)
      return myJSON as! Self
    } catch {
      fatalError("Err")
    }
  }
}

