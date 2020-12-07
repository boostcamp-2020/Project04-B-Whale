//
//  MemberUpdateCoordinator.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/07.
//

import UIKit
import NetworkFramework

final class MemberUpdateCoordinator: NavigationCoordinator {
  
  // MARK:- Property
  
  var navigationController: UINavigationController?
  private var storyboard: UIStoryboard {
    return UIStoryboard.load(storyboard: .memberUpdate)
  }
  private let router: Routable
  
  
  // MARK:- Initializer
  
  init(router: Routable) {
    self.router = router
  }
  
  
  // MARK:- Method
  
  func start() -> UIViewController {
    guard let memberUpdateViewController = storyboard.instantiateViewController(
            identifier: MemberUpdateViewController.identifier,
            creator: { coder in
              let viewModel = MemberUpdateViewModel()
              
              return MemberUpdateViewController(
                coder: coder,
                viewModel: viewModel
              )
            }) as? MemberUpdateViewController
    else { return UIViewController() }
    
    return memberUpdateViewController
  }
}
