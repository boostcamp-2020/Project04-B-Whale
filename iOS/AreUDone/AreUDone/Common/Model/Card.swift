//
//  Card.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/23.
//

import Foundation
import MobileCoreServices
import RealmSwift

final class Cards: Object, Codable {
  
  // MARK: - Property
  
  var cards = List<Card>()
  
  
  // MARK: - Initializer
  
  required convenience init(from decoder: Decoder) throws {
    self.init()
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let decodedCards = try container.decodeIfPresent([Card].self, forKey: .cards) ?? []
    
    cards.append(objectsIn: decodedCards)
  }
  
  
  // MARK: - Method
  
  func fetchCards() -> [Card] {
    return Array(cards)
  }
}

final class Card: Object, Codable {
  
  // MARK: - Property
  
  @objc dynamic var id: Int = UUID().hashValue
  @objc dynamic var title: String = ""
  @objc dynamic var dueDate: String = ""
  @objc dynamic var position: Double = 0
  @objc dynamic var commentCount: Int = 0
  
  override class func primaryKey() -> String? {
    return "id"
  }

  private enum CodingKeys: String, CodingKey {
    case id, title, dueDate, position, commentCount
  }
  
  // MARK: - Initializer
  
  required convenience init(from decoder: Decoder) throws {
    self.init()
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id = try container.decode(Int.self, forKey: .id)
    self.title = try container.decode(String.self, forKey: .title)
    self.dueDate = try container.decode(String.self, forKey: .dueDate)
    self.position = try container.decodeIfPresent(Double.self, forKey: .position) ?? 0
    self.commentCount = try container.decodeIfPresent(Int.self, forKey: .commentCount) ?? 0
  }
  
  
  // MARK: - Method
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(self.id, forKey: .id)
    try container.encode(self.title, forKey: .title)
    try container.encode(self.dueDate, forKey: .dueDate)
    try container.encode(self.position, forKey: .position)
    try container.encode(self.commentCount, forKey: .commentCount)
  }
}


// MARK: - Extension NSItemProviderWriting

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
        completionHandler(nil, error)
      }
    }
  
    return nil
  }
}


// MARK: - Extension NSItemProviderReading

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
