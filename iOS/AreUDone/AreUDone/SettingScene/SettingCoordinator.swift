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
  var sceneCoordinator: Coordinator?
  
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
    
    settingViewController.coordinator = self
    
    return settingViewController
  }
}


extension SettingCoordinator {
  
  func logout() {
    Keychain.shared.removeValue(forKey: "token")
    sceneCoordinator?.start()
  }
}
