//
//  BoardEndPoint.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import Foundation
import NetworkFramework
import KeychainFramework

enum BoardEndPoint {
  case createBoard(title: String, color: String)
  case inviteUserToBoard(boardId: Int, userId: Int)

  case fetchAllBoards
  case fetchBoardDetail(boardId: Int)

  case updateBoard(boardId: Int, title: String)
  
  case deleteBoard(boardId: Int)
  case exitBoard(boardId: Int, invitationId: Int)
}

extension BoardEndPoint: EndPointable {
  var environmentBaseURL: String {
    switch self {
    case .createBoard:
      return "\(APICredentials.ip)/api/board"
      
    case .inviteUserToBoard(let boardId, _):
      return "\(APICredentials.ip)/api/board/\(boardId)/invitation"
      
    case .fetchBoardDetail(let boardId):
      return "\(APICredentials.ip)/api/board/\(boardId)"
      
    case .fetchAllBoards:
      return "\(APICredentials.ip)/api/board"
      
    case .updateBoard(let boardId, _):
      return "\(APICredentials.ip)/api/board/\(boardId)"
      
    case .deleteBoard(let boardId):
      return "\(APICredentials.ip)/api/board/\(boardId)"
      
    case .exitBoard(let boardId, let invitationId):
      return "\(APICredentials.ip)/api/board/\(boardId)/invitation/\(invitationId)"
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
    
    case .createBoard, .inviteUserToBoard:
      return .POST
      
    case .fetchAllBoards, .fetchBoardDetail:
      return .GET
      
    case .updateBoard:
      return .PUT
      
    case .deleteBoard, .exitBoard:
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
    case .createBoard(let title, let color):
      return ["title": title, "color": color]
      
    case .inviteUserToBoard(_, let userId):
      return ["userId": "\(userId)"]
      
    case .updateBoard(_, let title):
      return ["title": title]
      
    default:
      return nil
    }
  }
}

