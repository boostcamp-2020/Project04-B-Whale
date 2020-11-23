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
  
  case fetchDailyCards(date: String)
}

extension CardEndPoint: EndPointable {
  var environmentBaseURL: String {
    switch self {
    case .fetchDailyCards:
      return "\(APICredentials.ip)/api/card"
    }
  }
  
  var baseURL: URLComponents {
    guard let url = URLComponents(string: environmentBaseURL) else { fatalError() } // TODO: 예외처리로 바꿔주기
    return url
  }
  
  var query: HTTPQuery? {
    switch self {
    case .fetchDailyCards(let date): // ?q=date:2020-01-01
      return ["q": "date:\(date)"]
    }
  }
  
  var httpMethod: HTTPMethod? {
    switch self {
    case .fetchDailyCards:
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
