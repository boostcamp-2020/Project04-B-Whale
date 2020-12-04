//
//  UserEndPoint.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/02.
//

import Foundation
import NetworkFramework

enum LoginFlatform: String {
  case naver
}

enum UserEndPoint {
  
  case requestLogin(flatform: LoginFlatform)
  case requestMe
}

extension UserEndPoint: EndPointable {
  
  var environmentBaseURL: String {
    switch self {
    case .requestLogin(let flatform):
      return "\(APICredentials.ip)/api/oauth/login/\(flatform.rawValue)"
      
    case .requestMe:
      return "\(APICredentials.ip)/api/user/me"
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
      
    case .requestMe:
      return nil
    }
  }
  
  var httpMethod: HTTPMethod? {
    switch self {
    case .requestLogin:
      return .get
      
    case .requestMe:
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
