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
  
  private let userService: UserServiceProtocol
  
  init(userService: UserServiceProtocol) {
    self.userService = userService
  }
  
}
