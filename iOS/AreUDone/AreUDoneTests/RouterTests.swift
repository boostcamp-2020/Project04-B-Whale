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
    CardService(router: MockRouter(jsonFactory: CardTrueJsonFactory())).fetchDailyCards(date: "") { result in
      switch result {
      case .success:
        XCTAssert(true)
      case .failure:
        XCTAssert(false)
      }
    }
  }
  
  func testMockRouter_비유효데이터() {
    CardService(router: MockRouter(jsonFactory: CardFalseJsonFactory())).fetchDailyCards(date: "") { result in
      switch result {
      case .success:
        XCTAssert(false)
      case .failure(let error):
        if error == .data {
          XCTAssert(true)
        } else {
          XCTAssert(false)
        }
        
      }
    }
  }
}
