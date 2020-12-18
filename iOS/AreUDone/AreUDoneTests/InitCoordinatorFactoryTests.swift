//
//  InitCoordinatorFactoryTests.swift
//  AreUDoneTests
//
//  Created by a1111 on 2020/11/21.
//

import XCTest

class InitCoordinatorFactoryTests: XCTestCase {
  
  var factory: InitCoorndinatorFactory!
  
  override func setUpWithError() throws {
    factory = InitCoorndinatorFactory()
  }
  
  override func tearDownWithError() throws {
    
  }
  
  func testInitCoordinatorFactory_인스턴스_생성() {
    XCTAssertNotNil(factory)
  }
  
  func testInitCoordinatorFactory_탭바코디네이터_반환() {
    let coordinator = factory.coordinator(by: .isSigned, with: Router())
    
    XCTAssertTrue(coordinator is TabbarCoordinator)
  }
  
  func testInitCoordinatorFactory_signin코디네이터_반환() {
    let coordinator = factory.coordinator(by: .isNotSigned, with: Router())
    
    XCTAssertTrue(coordinator is SigninCoordinator)
  }
}
