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
  
  case fetchDailyCards(dateString: String)
  case fetchDetailCard(id: Int)
  case updateCard(
        id: Int,
        listId: Int?,
        title: String?,
        content: String?,
        position: String?,
        dueDate: String?
       )
  case updateCardMember(id: Int, userIds: [Int])
  case fetchCardsCount(startDate: String, endDate: String, member: String?)
}

extension CardEndPoint: EndPointable {
  var environmentBaseURL: String {
    switch self {
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
    }
  }
  
  var baseURL: URLComponents {
    guard let url = URLComponents(string: environmentBaseURL) else { fatalError() } // TODO: 예외처리로 바꿔주기
    return url
  }
  
  var query: HTTPQuery? {
    switch self {
    case .fetchDailyCards(let dateString): // ?q=date:2020-01-01
      return ["q": "date:\(dateString)"]
      
    case .fetchDetailCard:
      return nil
      
    case .updateCard:
      return nil
      
    case .updateCardMember:
      return nil
      
    case .fetchCardsCount(let startDate, let endDate, let member):
      var value = "startdate:" + startDate + " " + "enddate:" + endDate
      if let member = member {
        value += " " + member
      }
      return ["q": value]
    }
  }
  
  var httpMethod: HTTPMethod? {
    switch self {
    case .fetchDailyCards:
      return .get
      
    case .fetchDetailCard:
      return .get
      
    case .updateCard:
      return .PATCH
      
    case .updateCardMember:
      return .put
      
    case .fetchCardsCount:
      return .get
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
    case .updateCard(
          _,
          let listId,
          let title,
          let content,
          let position,
          let dueDate
    ):
      var body = [String: String]()
      if let listId = listId {
        body["listId"] = "\(listId)"
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
