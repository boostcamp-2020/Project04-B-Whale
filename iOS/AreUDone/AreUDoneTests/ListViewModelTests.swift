//
//  ListViewModelTests.swift
//  AreUDoneTests
//
//  Created by a1111 on 2020/11/30.
//

import XCTest

class ListViewModelTests: XCTestCase {
  
  private var viewModel: ListViewModelProtocol!
  
  override func setUpWithError() throws {
    
    let list = List(id: 0, title: "", position: 0, cards: [])
    viewModel = ListViewModel(list: list)
  }
  
  override func tearDownWithError() throws {
    viewModel = nil
  }
  
  func test_인스턴스_생성() {
    XCTAssertNotNil(viewModel)
  }
  
  func test_append() {
    let repeatNumber = 5
    
    (0..<repeatNumber).forEach {
      let card = Card(id: $0, title: "", dueDate: "", position: 0, commentCount: 0)
      viewModel.append(card: card)
    }
    
    XCTAssertEqual(viewModel.numberOfCards(), repeatNumber)
    (0..<repeatNumber).forEach {
      let fetchedCard = viewModel.fetchCard(at: $0)
      XCTAssertEqual(fetchedCard.id, $0)
    }
  }
  
  func test_insert() {
    let repeatNumber = 5

    (0..<repeatNumber).forEach {
      let card = Card(id: $0, title: "", dueDate: "", position: 0, commentCount: 0)
      viewModel.insert(card: card, at: $0)
    }

    XCTAssertEqual(viewModel.numberOfCards(), repeatNumber)
    (0..<repeatNumber).forEach {
      let fetchedCard = viewModel.fetchCard(at: $0)
      XCTAssertEqual(fetchedCard.id, $0)
    }
  }
  
  func test_remove() {
    let repeatNumber = 5

    (0..<repeatNumber).forEach {
      let card = Card(id: $0, title: "", dueDate: "", position: 0, commentCount: 0)
      viewModel.append(card: card)
    }
    
    (0..<repeatNumber).forEach { _ in
      viewModel.removeCard(at: 0)
    }
    XCTAssertEqual(viewModel.numberOfCards(), 0)
  }
  
  func test_업데이트IndexPath_smallToBig() {
    let first = IndexPath(item: 0, section: 0)
    let second = IndexPath(item: 5, section: 0)
    let updatedIndexPath = viewModel.makeUpdatedIndexPaths(by: first, and: second)
    
    XCTAssertEqual(updatedIndexPath.count, 6)
    
    (0...5).forEach {
      XCTAssertEqual(updatedIndexPath[$0].item, $0)
    }
  }
  
  func test_업데이트IndexPath2_bigToSmall() {
    let first = IndexPath(item: 5, section: 0)
    let second = IndexPath(item: 0, section: 0)
    let updatedIndexPath = viewModel.makeUpdatedIndexPaths(by: first, and: second)
    
    XCTAssertEqual(updatedIndexPath.count, 6)
    
    (0...5).forEach {
      XCTAssertEqual(updatedIndexPath[$0].item, $0)
    }
  }
}
