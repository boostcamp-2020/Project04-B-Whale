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
    let dic = ["title": "보드제목", "color": "#252525"]
    
    let endPoint = BoardEndPoint.createBoard(title: dic["title"]!, color: dic["color"]!)
    boardService.createBoard(withTitle: dic["title"]!, color: dic["color"]!) { _ in
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 3.0)
    
    let urlRequest = mockRouter.urlRequest
    let bodyData = urlRequest!.httpBody
    let bodyString = String(data: bodyData!, encoding: String.Encoding.utf8)!
    
    XCTAssertEqual(endPoint.baseURL.url, urlRequest?.url)
    XCTAssertEqual(endPoint.httpMethod?.rawValue.lowercased(), urlRequest?.httpMethod?.lowercased())
    XCTAssertEqual(dic.encode().toDictionary(), bodyString.toDictionary())
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
