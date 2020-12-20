//
//  BoardAddViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/07.
//

import Foundation

protocol BoardAddViewModelProtocol {
  
  func bindingIsCreateEnable(handler: @escaping (Bool) -> Void)
  func bindingUpdateBoardColor(handler: @escaping (String) -> Void)
  func bindingDismiss(handler: @escaping () -> Void)
  
  func createBoard()

  func updateBoardTitle(to title: String)
  func updateRGBHexString(completionHandler: ((String) -> Void)?)
}

extension BoardAddViewModelProtocol {
  
  func updateRGBHexString(completionHandler: ((String) -> Void)? = nil) {
    updateRGBHexString(completionHandler: completionHandler)
  }
}

final class BoardAddViewModel: BoardAddViewModelProtocol {
  
  // MARK: - Property
  
  private let boardService: BoardServiceProtocol
  
  private var isCreateEnableHandler: ((Bool) -> Void)?
  private var updateBoardColorHandler: ((String) -> Void)?
  private var dismissHandler: (() -> Void)?
  
  private var boardTitle: String = "" {
    didSet {
      check(title: boardTitle)
    }
  }
  private var rgbHexString: String = "" {
    didSet {
      check(title: boardTitle)
    }
  }

  
  // MARK: - Initializer
  
  init(boardService: BoardServiceProtocol) {
    self.boardService = boardService
    
    rgbHexString = makeRandomRGBHexString()
  }
  
  
  // MARK: - Method
  
  func createBoard() {
    boardService.createBoard(withTitle: boardTitle, color: rgbHexString) { result in
      switch result {
      case .success:
        self.dismissHandler?()
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func updateBoardTitle(to title: String) {
    let trimmedTitle = title.trimmed
    boardTitle = trimmedTitle
  }
  
  func updateRGBHexString(completionHandler: ((String) -> Void)?) {
    rgbHexString = makeRandomRGBHexString()
    completionHandler?(rgbHexString)
    updateBoardColorHandler?(rgbHexString)
  }
}


// MARK: - Extension

private extension BoardAddViewModel {
  
  func check(title: String) {
    if boardTitle.isEmpty {
      isCreateEnableHandler?(false)
    } else {
      isCreateEnableHandler?(true)
    }
  }
  
  func makeRandomRGBHexString() -> String {
    var hexString = "#"
    let digits = [
      "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
      "a", "b", "c", "d", "e", "f"
    ]
    
    (0..<6).forEach { _ in
      hexString += digits.randomElement() ?? "0"
    }
    
    return hexString
  }
}


// MARK: - Extension BindUI

extension BoardAddViewModel {
  
  func bindingIsCreateEnable(handler: @escaping (Bool) -> Void) {
    isCreateEnableHandler = handler
  }
  
  func bindingUpdateBoardColor(handler: @escaping (String) -> Void) {
    updateBoardColorHandler = handler
  }
  
  func bindingDismiss(handler: @escaping () -> Void) {
    dismissHandler = handler
  }
}
