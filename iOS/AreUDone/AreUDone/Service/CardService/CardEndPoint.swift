//
//  CardEndPoint.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/23.
//

import Foundation
import NetworkFramework
import KeychainFramework

enum CardEndPoint {
  
  case fetchDailyCards(dateString: String, option: FetchDailyCardsOption = .allCard)
  case createCard(listId: Int, title: String, dueDate: String, content: String)
  case fetchDetailCard(id: Int)
  case updateCard(
        id: Int,
        listId: Int?,
        title: String?,
        content: String?,
        position: Double?,
        dueDate: String?
       )
  case updateCardMember(id: Int, userIds: [Int])
  case fetchCardsCount(startDate: String, endDate: String)
  case deleteCard(id: Int)
}

extension CardEndPoint: EndPointable {
  var environmentBaseURL: String {
    switch self {
    case .createCard(let listId, _, _, _):
      return "\(APICredentials.ip)/api/list/\(listId)/card"
      
    case .fetchDailyCards:
      return "\(APICredentials.ip)/api/card"
      
    case .fetchDetailCard(let id):
      return "\(APICredentials.ip)/api/card/\(id)"
      
    case .updateCard(let id, _, _, _, _, _):
      return "\(APICredentials.ip)/api/card/\(id)"
      
    case .updateCardMember(let id, _):
      return "\(APICredentials.ip)/api/card/\(id)/member"
      
    case .fetchCardsCount:
      return "\(APICredentials.ip)/api/card/count"
      
    case .deleteCard(let id):
      return "\(APICredentials.ip)/api/card/\(id)"
    }
  }
  
  var baseURL: URLComponents {
    guard let url = URLComponents(string: environmentBaseURL) else { fatalError() } // TODO: 예외처리로 바꿔주기
    return url
  }
  
  var query: HTTPQuery? {
    switch self {
    case .fetchDailyCards(let dateString, let option): // ?q=date:2020-01-01 member:me
      var value = "date:\(dateString)"
      
      if let optionValue = option.value {
        value += " member:\(optionValue)"
      }
      
      return ["q": value]
      
    case .createCard:
      return nil
      
    case .fetchDetailCard:
      return nil
      
    case .updateCard:
      return nil
      
    case .updateCardMember:
      return nil
      
    case .fetchCardsCount(let startDate, let endDate):
      return ["q": "startdate:\(startDate) enddate:\(endDate) member:me"]
      
    case .deleteCard:
      return nil
    }
  }
  
  var httpMethod: HTTPMethod? {
    switch self {
    case .createCard:
      return .POST
      
    case .fetchDailyCards:
      return .GET
      
    case .fetchDetailCard:
      return .GET
      
    case .updateCard:
      return .PATCH
      
    case .updateCardMember:
      return .PUT
      
    case .fetchCardsCount:
      return .GET
      
    case .deleteCard:
      return .DELETE
    }
  }
  
  var headers: HTTPHeader? {
    guard let accessToken = Keychain.shared.loadValue(forKey: "token")
    else { return nil }
    
    return [
      "Authorization": "\(accessToken)",
      "Content-Type": "application/json",
      "Accept": "application/json"
    ]
  }
  
  var bodies: HTTPBody? {
    switch self {
    case .createCard(_, let title, let dueDate, let content):
      return ["title": title, "dueDate": dueDate, "content": content]
      
    case .updateCard(
      _,
      let listId,
      let title,
      let content,
      let position,
      let dueDate
    ):
      var body = [String: Any]()
      if let listId = listId {
        body["listId"] = listId
      }
      
      if let title = title {
        body["title"] = title
      }
      
      if let content = content {
        body["content"] = content
      }
      
      if let position = position {
        body["position"] = position
      }
      
      if let dueDate = dueDate {
        body["dueDate"] = dueDate
      }
      
      return body
      
    case .updateCardMember(_, let userIds):
      return ["userIds": userIds]
      
    default:
      return nil
    }
  }
}
