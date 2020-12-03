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
  
  case fetchAllBoards
  case addBoard(title: String)
  case updateBoard(boardId: Int, title: String)
  case deleteBoard(boardId: Int)
  
  case inviteUserToBoard(boardId: Int, userId: Int)
  case exitBoard(boardId: Int, invitationId: Int)
  case fetchBoardDetail(boardId: Int)
}

extension BoardEndPoint: EndPointable {
  var environmentBaseURL: String {
    switch self {
    case .fetchAllBoards:
      return "\(APICredentials.ip)/api/board"
      
    case .addBoard:
      return "\(APICredentials.ip)/api/board"
      
    case .updateBoard(let boardId, _):
      return "\(APICredentials.ip)/api/board/\(boardId)"
      
    case .deleteBoard(let boardId):
      return "\(APICredentials.ip)/api/board/\(boardId)"
      
    case .inviteUserToBoard(let boardId, _):
      return "\(APICredentials.ip)/api/board/\(boardId)/invitation"
      
    case .exitBoard(let boardId, let invitationId):
      return "\(APICredentials.ip)/api/board/\(boardId)/invitation/\(invitationId)"
      
    case .fetchBoardDetail(let boardId):
      return "\(APICredentials.ip)/api/board/\(boardId)"
    }
  }
  
  var baseURL: URLComponents {
    guard let url = URLComponents(string: environmentBaseURL) else { fatalError() } // TODO: 예외처리로 바꿔주기
    return url
  }
  
  var query: HTTPQuery? {
    return nil
  }
  
  var httpMethod: HTTPMethod? {
    switch self {
    case .fetchAllBoards, .fetchBoardDetail:
      return .get
      
    case .addBoard, .updateBoard, .inviteUserToBoard:
      return .post
      
    case .deleteBoard, .exitBoard:
      return .delete
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
    switch self {
    case .addBoard(let title):
      return ["title": title]
      
    case .updateBoard(_, let title):
      return ["title": title]
      
    case .inviteUserToBoard(_, let userId):
      return ["userId": "\(userId)"]
      
    default:
      return nil
    }
  }
}

