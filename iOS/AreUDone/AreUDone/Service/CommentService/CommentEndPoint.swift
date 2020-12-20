//
//  CommentEndPoint.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/08.
//

import Foundation
import NetworkFramework

enum CommentEndPoint {
  
  case createComment(cardId: Int, content: String)
  case deleteComment(commentId: Int)
}

extension CommentEndPoint: EndPointable {
  
  var environmentBaseURL: String {
    switch self {
    case .createComment(let cardId, _):
      return "\(APICredentials.ip)/api/card/\(cardId)/comment"
      
    case .deleteComment(let commentId):
      return "\(APICredentials.ip)/api/comment/\(commentId)"
    }
  }
  
  var baseURL: URLComponents {
    guard let url = URLComponents(string: environmentBaseURL) else { fatalError() } 
    return url
  }
  
  var query: HTTPQuery? {
    return nil
  }
  
  var httpMethod: HTTPMethod? {
    switch self {
    case .createComment:
      return .POST
      
    case .deleteComment:
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
    case .createComment(_, let content):
      return ["content": content]
      
    case .deleteComment:
      return nil
    }
  }
}
