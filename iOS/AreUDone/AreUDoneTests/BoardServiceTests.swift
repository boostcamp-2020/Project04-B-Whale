//
//  BoardServiceTests.swift
//  AreUDoneTests
//
//  Created by a1111 on 2020/12/07.
//

import XCTest

class BoardServiceTests: XCTestCase {
  
  let mockRouter = MockRouter()
  var boardService: BoardServiceProtocol!
  
  override func setUpWithError() throws {
    boardService = BoardService(router: mockRouter)
  }
  
  override func tearDownWithError() throws {
    boardService = nil
  }
  
  func test_fetchAllBoard() {
    let expectation = XCTestExpectation(description: "FetchAllBoardExpectation")
    
    let endPoint = BoardEndPoint.fetchAllBoards
    boardService.fetchAllBoards { _ in
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 3.0)
    
    let urlRequest = mockRouter.urlRequest
    XCTAssertEqual(endPoint.baseURL.url, urlRequest?.url)
    XCTAssertEqual(endPoint.httpMethod?.rawValue.lowercased(), urlRequest?.httpMethod?.lowercased())
  }
  
  func test_createBoard() {
    let expectation = XCTestExpectation(description: "createBoardExpectation")
    let body = ["title": "보드제목", "color": "#252525"]
    
    let endPoint = BoardEndPoint.createBoard(title: body["title"]!, color: body["color"]!)
    boardService.createBoard(withTitle: body["title"]!, color: body["color"]!) { _ in
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 3.0)
    
    let urlRequest = mockRouter.urlRequest
    let bodyData = urlRequest!.httpBody
    let bodyString = String(data: bodyData!, encoding: String.Encoding.utf8)!
    
    XCTAssertEqual(endPoint.baseURL.url, urlRequest?.url)
    XCTAssertEqual(endPoint.httpMethod?.rawValue.lowercased(), urlRequest?.httpMethod?.lowercased())
    XCTAssertEqual(body.encode().toDictionary(), bodyString.toDictionary())
  }
  
  func test_updateBoard() {
    let expectation = XCTestExpectation(description: "updateBoardExpectation")
    let query = ["boardId": 1]
    let body = ["title": "보드 제목"]
    
    let endPoint = BoardEndPoint.updateBoard(boardId: query["boardId"]!, title: body["title"]!)
    boardService.updateBoard(with: query["boardId"]!, title: body["title"]!) { _ in
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 3.0)
    
    let urlRequest = mockRouter.urlRequest
    let bodyData = urlRequest!.httpBody
    let bodyString = String(data: bodyData!, encoding: String.Encoding.utf8)!
    
    XCTAssertEqual(endPoint.baseURL.url, urlRequest?.url)
    XCTAssertEqual(endPoint.httpMethod?.rawValue.lowercased(), urlRequest?.httpMethod?.lowercased())
    XCTAssertEqual(body.encode().toDictionary(), bodyString.toDictionary())
  }
  
  func test_deleteBoard() {
    let expectation = XCTestExpectation(description: "deleteBoardExpectation")
    let query = ["boardId": 1]
    
    let endPoint = BoardEndPoint.deleteBoard(boardId: query["boardId"]!)
    boardService.deleteBoard(with: query["boardId"]!) { result in
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 3.0)
    
    let urlRequest = mockRouter.urlRequest
    XCTAssertEqual(endPoint.baseURL.url, urlRequest?.url)
    XCTAssertEqual(endPoint.httpMethod?.rawValue.lowercased(), urlRequest?.httpMethod?.lowercased())
  }
  
  func test_inviteUserToBoard() {
    let expectation = XCTestExpectation(description: "inviteUserToBoardExpectation")
    let query = ["boardId": 1]
    let body = ["userId": 1]
    
    let endPoint = BoardEndPoint.inviteUserToBoard(boardId: query["boardId"]!, userId: body["userId"]!)
    boardService.requestInvitation(withBoardId: query["boardId"]!, andUserId: body["userId"]!) { _ in
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 3.0)
    
    let urlRequest = mockRouter.urlRequest
    let bodyData = urlRequest!.httpBody
    let bodyString = String(data: bodyData!, encoding: String.Encoding.utf8)!
    
    XCTAssertEqual(endPoint.baseURL.url, urlRequest?.url)
    XCTAssertEqual(endPoint.httpMethod?.rawValue.lowercased(), urlRequest?.httpMethod?.lowercased())
    XCTAssertEqual(body.encode().toDictionary(), bodyString.toDictionary())
  }
  
  func test_fetchBoardDetail() {
    let expectation = XCTestExpectation(description: "FetchBoardDetailExpectation")
    let query = ["boardId": 1]
    
    let endPoint = BoardEndPoint.fetchBoardDetail(boardId: query["boardId"]!)
    
    boardService.fetchBoardDetail(with: query["boardId"]!) { _ in
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 3.0)
    
    let urlRequest = mockRouter.urlRequest
    
    XCTAssertEqual(endPoint.baseURL.url, urlRequest?.url)
    XCTAssertEqual(endPoint.httpMethod?.rawValue.lowercased(), urlRequest?.httpMethod?.lowercased())
  }
}

extension String {
  
  func toDictionary() -> [String: String] {
    var dic: [String: String] = [:]
    let parameters = self.components(separatedBy: "&")
    parameters.forEach { str in
      let part = str.components(separatedBy: "=")
      let key = part.first!
      let value = part.last!
      
      dic[key] = value
    }
    return dic
  }
}
