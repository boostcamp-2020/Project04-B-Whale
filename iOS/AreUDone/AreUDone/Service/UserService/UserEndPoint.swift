//
//  UserEndPoint.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/02.
//

import Foundation
import NetworkFramework

enum LoginPlatform: String {
  case naver
  case github
}

enum UserEndPoint {
  
  case requestLogin(flatform: LoginPlatform)
  case requestMe
  case searchUser(userName: String)
}

extension UserEndPoint: EndPointable {
  
  var environmentBaseURL: String {
    switch self {
    case .requestLogin(let flatform):
      return "\(APICredentials.ip)/api/oauth/login/\(flatform.rawValue)"
      
    case .requestMe:
      return "\(APICredentials.ip)/api/user/me"
      
    case .searchUser:
      return "\(APICredentials.ip)/api/user"
    }
  }
  
  var baseURL: URLComponents {
    guard let url = URLComponents(string: environmentBaseURL) else { fatalError() } // TODO: 예외처리로 바꿔주기
    return url
  }
  
  var query: HTTPQuery? {
    switch self {
    
    case .searchUser(let userName):
      return ["username": userName]
    
    default:
      return nil
    }
  }
  
  var httpMethod: HTTPMethod? {
    switch self {
    case .requestLogin,
         .requestMe,
         .searchUser:
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
