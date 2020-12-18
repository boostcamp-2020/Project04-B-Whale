//
//  AreUDoneTests.swift
//  AreUDoneTests
//
//  Created by a1111 on 2020/11/18.
//

import XCTest
//@testable import AreUDone

class AreUDoneTests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  
  func testVideoPlayerLooper_인스턴스_생성() {
     XCTAssertNotNil(VideoPlayerLooper())
  }
}
