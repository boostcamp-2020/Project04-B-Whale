//
//  InvitationViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/05.
//

import Foundation

protocol InvitationViewModelProtocol {
  
  func bindingUpdateInvitationTableView(handler: @escaping () -> Void) // reload
  
  func searchUser(of userName: String)
  func addUserToBoard(of index: Int)
}

final class InvitationViewModel: InvitationViewModelProtocol {
  
  // MARK: - Property
  
  private let userService: UserServiceProtocol
  private let boardService: BoardServiceProtocol
  
  private var updateInvitationTableViewHandler: (() -> Void)?

  
  // MARK: - Initializer
  
  init(userService: UserServiceProtocol, boardService: BoardServiceProtocol) {
    self.userService = userService
    self.boardService = boardService
  }
  
  func searchUser(of userName: String) {
    userService.fetchUserInfo(userName: userName) { result in
      switch result {
      case .success(let user):
        print(user)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func addUserToBoard(of index: Int) {
    // TODO: API 물어본 후 변경
  }
}


// MARK: - Extension BindUI

extension InvitationViewModel {
  
  func bindingUpdateInvitationTableView(handler: @escaping () -> Void) {
    updateInvitationTableViewHandler = handler
  }
}
