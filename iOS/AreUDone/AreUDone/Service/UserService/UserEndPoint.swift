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
  
  case fetchMyInfo
  case fetchUserInfo(userName: String)
}

extension UserEndPoint: EndPointable {
    
  var environmentBaseURL: String {
    switch self {
    case .requestLogin(let flatform):
      return "\(APICredentials.ip)/api/oauth/login/\(flatform.rawValue)"
      
    case .fetchMyInfo:
      return "\(APICredentials.ip)/api/user/me"
      
    case .fetchUserInfo:
      return "\(APICredentials.ip)/api/user"
    }
  }
  
  var baseURL: URLComponents {
    guard let url = URLComponents(string: environmentBaseURL) else { fatalError() }
    return url
  }
  
  var query: HTTPQuery? {
    switch self {
    
    case .fetchUserInfo(let userName):
      return ["username": userName]
      
    default:
      return nil
    }
  }
  
  var httpMethod: HTTPMethod? {
    switch self {
    case .requestLogin,
         .fetchMyInfo,
         .fetchUserInfo:
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
