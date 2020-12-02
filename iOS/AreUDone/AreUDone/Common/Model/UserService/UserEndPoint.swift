//
//  UserEndPoint.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/02.
//

import Foundation
import NetworkFramework

enum UserEndPoint {
  
  enum Flatform: String {
    case naver
    case apple
  }
  
  case requestLogin(flatform: Flatform)
}

extension UserEndPoint: EndPointable {
  
  var environmentBaseURL: String {
    switch self {
    case .requestLogin(let flatform):
      return "\(APICredentials.ip)/api/auth/login/\(flatform.rawValue)"
    }
  }
  
  var baseURL: URLComponents {
    guard let url = URLComponents(string: environmentBaseURL) else { fatalError() } // TODO: 예외처리로 바꿔주기
    return url
  }
  
  var query: HTTPQuery? {
    switch self {
    case .requestLogin:
      return nil
    }
  }
  
  var httpMethod: HTTPMethod? {
    switch self {
    case .requestLogin:
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
