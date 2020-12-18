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
    return Array(cards)
  }
}

class Card: Object, Codable {
  @objc dynamic var id: Int = UUID().hashValue
  @objc dynamic var title: String = ""
  @objc dynamic var dueDate: String = ""
  @objc dynamic var position: Double = 0
  @objc dynamic var commentCount: Int = 0

  private enum CodingKeys: String, CodingKey {
    case id, title, dueDate, position, commentCount
  }
  
  required convenience init(from decoder: Decoder) throws {
    self.init()
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(Int.self, forKey: .id)
    self.title = try container.decode(String.self, forKey: .title)
    self.dueDate = try container.decode(String.self, forKey: .dueDate)
    self.position = try container.decodeIfPresent(Double.self, forKey: .position) ?? 0
    self.commentCount = try container.decodeIfPresent(Int.self, forKey: .commentCount) ?? 0
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.id, forKey: .id)
    try container.encode(self.title, forKey: .title)
    try container.encode(self.dueDate, forKey: .dueDate)
    try container.encode(self.position, forKey: .position)
    try container.encode(self.commentCount, forKey: .commentCount)
  }

  override class func primaryKey() -> String? {
    return "id"
  }
}

extension Card: NSItemProviderWriting {
  static var writableTypeIdentifiersForItemProvider: [String] {
    
    return [kUTTypeData as String]
  }
  
  func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Swift.Void) -> Progress? {
    DispatchQueue.main.async {
      
      do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        
        completionHandler(data, nil)
        
      } catch {
        print(error)
        completionHandler(nil, error)
      }
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
      print(error)
      fatalError("Err")
    }
  }
}
