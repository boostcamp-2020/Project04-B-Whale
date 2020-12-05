//
//  InvitationCoordinator.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/05.
//

import UIKit
import NetworkFramework

final class InvitationCoordinator: NavigationCoordinator {
  var navigationController: UINavigationController?
  
  private var storyboard: UIStoryboard {
    UIStoryboard.load(storyboard: .invitation)
  }
  
  func start() -> UIViewController {
    
    guard let invitationViewController = storyboard.instantiateViewController(
            identifier: InvitationViewController.identifier,
            creator: { coder in
              
              let userService = UserService(router: Router())
              let boardService = BoardService(router: Router())
              let viewModel = InvitationViewModel(userService: userService, boardService: boardService)
              
              
              return InvitationViewController(coder: coder, viewModel: viewModel)
            }) as? InvitationViewController else { return UIViewController() }
    
    invitationViewController.coordinator = self
    
    return invitationViewController
  }
}

extension InvitationCoordinator {
  
  func dismiss() {
    navigationController?.dismiss(animated: true)
  }
}
