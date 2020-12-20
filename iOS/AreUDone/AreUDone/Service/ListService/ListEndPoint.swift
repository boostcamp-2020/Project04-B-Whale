//
//  ListEndPoint.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/08.
//

import Foundation
import NetworkFramework
import KeychainFramework

enum ListEndPoint {
  case createList(boardId: Int, title: String)
  case updateList(listId: Int, position: Double?, title: String?)
  case deleteList(listId: Int)
}

extension ListEndPoint: EndPointable {
  var environmentBaseURL: String {
    switch self {
    case .createList(let boardId, _):
      return "\(APICredentials.ip)/api/board/\(boardId)/list"
      
    case .updateList(let listId, _, _):
      return "\(APICredentials.ip)/api/list/\(listId)"
      
    case .deleteList(let listId):
      return "\(APICredentials.ip)/api/list/\(listId)"
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
    case .createList:
      return .POST
      
    case .updateList:
      return .PATCH
      
    case .deleteList:
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
    case .createList(_, let title):
      return ["title": title]
      
    case .updateList(_, let position, let title):
      var body = [String: String]()
      
      if let position = position {
        body["position"] = "\(position)"
      }
      
      if let title = title {
        body["title"] = title
      }
      
      return body
    default:
      return nil
    }
  }
}


