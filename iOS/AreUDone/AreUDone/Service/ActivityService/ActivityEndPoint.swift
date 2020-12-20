//
//  ActivityEndPoint.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/02.
//

import Foundation
import NetworkFramework
import KeychainFramework

enum ActivityEndPoint {
  case fetchActivities(boardId: Int)
}

extension ActivityEndPoint: EndPointable {
  var environmentBaseURL: String {
    return "\(APICredentials.ip)/api/activity"
  }
  
  var baseURL: URLComponents {
    guard let url = URLComponents(string: environmentBaseURL) else { fatalError() } 
    return url
  }
  
  var query: HTTPQuery? {
    switch self {
    case .fetchActivities(let boardId):
      return ["boardId": "\(boardId)"]
    }
  }
  
  var httpMethod: HTTPMethod? {
    switch self {
    case .fetchActivities:
      return .GET
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
    return nil
  }
}
