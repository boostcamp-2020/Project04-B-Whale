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
  
  func updateBoardTitle(with title: String)
  func updateRGBHexString()
  func createBoard()
}

final class BoardAddViewModel: BoardAddViewModelProtocol {
  
  // MARK: - Property
  
  private let boardService: BoardServiceProtocol
  
  private var isCreateEnableHandler: ((Bool) -> Void)?
  private var updateBoardColorHandler: ((String) -> Void)?
  private var dismissHandler: (() -> Void)?
  
  private var boardTitle: String = "" {
    didSet {
      check(title: boardTitle, colorAsString: rgbHexString)
    }
  }
  private var rgbHexString: String = "" {
    didSet {
      check(title: boardTitle, colorAsString: rgbHexString)
    }
  }

  
  // MARK: - Initializer
  
  init(boardService: BoardServiceProtocol) {
    self.boardService = boardService
  }
  
  
  // MARK: - Method
  
  func updateBoardTitle(with title: String) {
    boardTitle = title
  }
  
  func updateRGBHexString() {
    var hexString = "#"
    let digits = [
      "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
      "a", "b", "c", "d", "e", "f"
    ]
    
    (0..<6).forEach { _ in
      hexString += digits.randomElement() ?? "0"
    }
    
    rgbHexString = hexString
    updateBoardColorHandler?(rgbHexString)
  }
  
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
}


// MARK: - Extension

private extension BoardAddViewModel {
  
  private func check(title: String, colorAsString: String) {
    if colorAsString.isEmpty || boardTitle.isEmpty {
      isCreateEnableHandler?(false)
    } else {
      isCreateEnableHandler?(true)
    }
  }
}

// MARK: - Extension UIBind

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
