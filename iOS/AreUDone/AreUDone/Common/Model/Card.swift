//
//  Card.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/23.
//

import Foundation
import MobileCoreServices
import RealmSwift

class Cards: Object, Codable {
  
  var cards = List<Card>()
  
  required convenience init(from decoder: Decoder) throws {
    self.init()
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let decodedCards = try container.decodeIfPresent([Card].self, forKey: .cards) ?? []
    
    cards.append(objectsIn: decodedCards)
  }
  
  func fetchCards() -> [Card] {
    var fetchedCards = [Card]()
    fetchedCards.append(contentsOf: cards)
    
    return fetchedCards
  }
}

class Card: Object, Codable {
  @objc dynamic var id: Int = 0
  @objc dynamic var title: String = ""
  @objc dynamic var dueDate: String = ""
  @objc dynamic var position: Double = 0.0
  @objc dynamic var commentCount: Int = 0

  required convenience init(from decoder: Decoder) throws {
    self.init()
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(Int.self, forKey: .id)
    self.title = try container.decode(String.self, forKey: .title)
    self.dueDate = try container.decode(String.self, forKey: .dueDate)
    self.position = try container.decodeIfPresent(Double.self, forKey: .position) ?? 0
    self.commentCount = try container.decodeIfPresent(Int.self, forKey: .commentCount) ?? 0
  }
  
  override class func primaryKey() -> String? {
    return "id"
  }
}

// NSObject 채택시 자동으로 Hashable 채택
extension Card: NSItemProviderWriting {
  static var writableTypeIdentifiersForItemProvider: [String] {
    
    return [kUTTypeData as String]
  }
  
  func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Swift.Void) -> Progress? {
    
    do {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      let data = try encoder.encode(self)
      
      completionHandler(data, nil)
      
    } catch {
      
      completionHandler(nil, error)
    }
    
    return nil
  }
}

extension Card: NSItemProviderReading {
  static var readableTypeIdentifiersForItemProvider: [String] {
    return [kUTTypeData as String]
  }
  
  static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
    let decoder = JSONDecoder()
    do {
      let myJSON = try decoder.decode(Card.self, from: data)
      return myJSON as! Self
    } catch {
      fatalError("Err")
    }
  }
}





//
//struct Card: Codable {
//    let id: Int
//    let title, dueDate: String
//    let commentCount: Int
//}
//
//extension Card: Hashable {
//
//  static func == (lhs: Card, rhs: Card) -> Bool {
//    return lhs.id == rhs.id
//  }
//
//  func hash(into hasher: inout Hasher) {
//    hasher.combine(id)
//  }
//}
//
