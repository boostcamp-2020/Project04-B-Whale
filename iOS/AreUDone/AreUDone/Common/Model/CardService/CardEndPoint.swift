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
}

extension CardEndPoint: EndPointable {
  var environmentBaseURL: String {
    switch self {
    case .fetchDailyCards:
      return "\(APICredentials.ip)/api/card"
      
    case .fetchDetailCard(let id):
      return "\(APICredentials.ip)/api/card/\(id)"
      
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
    }
  }
  
  var httpMethod: HTTPMethod? {
    switch self {
    case .fetchDailyCards:
      return .get
      
    case .fetchDetailCard:
      return .get
    }
  }
  
  var headers: HTTPHeader? {
    guard let accessToken = Keychain.shared.loadValue(forKey: "token")
    else { return nil }
    
    return [
      "Authorization": "Bearer \(accessToken))",
      "Cotent-Type": "application/json",
      "Accept": "application/json"
    ]
  }
  
  var bodies: HTTPBody? {
    return nil
  }
}
