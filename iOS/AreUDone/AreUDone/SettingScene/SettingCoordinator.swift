//
//  SettingCoordinator.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/15.
//

import UIKit
import NetworkFramework

final class SettingCoordinator: NavigationCoordinator {
  
  // MARK:- Property
  
  private var storyboard: UIStoryboard {
    return UIStoryboard.load(storyboard: .setting)
  }
  private let router: Routable
  var navigationController: UINavigationController?
  
  
  // MARK:- Initializer
  
  init(router: Routable) {
    self.router = router
  }
  
  // MARK:- Method
  
  func start() -> UIViewController {
    guard let settingViewController = storyboard.instantiateViewController(
      identifier: SettingViewController.identifier,
      creator: { coder in
        let settingViewModel = SettingViewModel()
        return SettingViewController(coder: coder, viewModel: settingViewModel)
      }
    ) as? SettingViewController
    else { return UIViewController() }
    
    return settingViewController
  }
}
