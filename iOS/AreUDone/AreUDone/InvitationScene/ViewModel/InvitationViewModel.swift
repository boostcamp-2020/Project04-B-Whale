//
//  InvitationViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/05.
//

import Foundation

protocol InvitationViewModelProtocol {
  
}

final class InvitationViewModel: InvitationViewModelProtocol {
  
  // MARK: - Property
  
  private let userService: UserServiceProtocol
  private let boardService: BoardServiceProtocol

  
  // MARK: - Initializer
  
  init(userService: UserServiceProtocol, boardService: BoardServiceProtocol) {
    self.userService = userService
    self.boardService = boardService
  }
}
