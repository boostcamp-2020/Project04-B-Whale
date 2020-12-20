//
//  RouterTests.swift
//  AreUDoneTests
//
//  Created by a1111 on 2020/11/23.
//

import XCTest


class RouterTests: XCTestCase {
  
  override func setUpWithError() throws {
  }
  
  override func tearDownWithError() throws {
  }
  
  func testMockRouter_유효데이터() {
    let expectation = XCTestExpectation(description: "ValidDataExpectation")
    var cards: Cards?
      
    CardService(router: MockRouter(jsonFactory: CardTrueJsonFactory())).fetchDailyCards(dateString: "") { result in
      switch result {
      case .success(let data):
        cards = data
      case .failure:
        break
      }
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 3.0)
    XCTAssertNotNil(cards)
    
  }
  
  func testMockRouter_비유효데이터() {
    let expectation = XCTestExpectation(description: "InValidDataExpectation")
    var cards: Cards?
    var expectedError: APIError?
    
    CardService(router: MockRouter(jsonFactory: CardFalseJsonFactory())).fetchDailyCards(dateString: "") { result in
      switch result {
      case .success(let data):
        cards = data
        
      case .failure(let error):
        expectedError = error
      }
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 3.0)
    
    XCTAssertNil(cards)
    XCTAssertEqual(expectedError, APIError.decodingJSON)
    
  }
}
