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
  
  private let router: Routable

  private var storyboard: UIStoryboard {
    return UIStoryboard.load(storyboard: .setting)
  }
  
  weak var sceneCoordinator: Coordinator?
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
    
    settingViewController.coordinator = self
    
    return settingViewController
  }
}


extension SettingCoordinator {
  
  func logout() {
    Keychain.shared.removeValue(forKey: KeyChainConstant.token)
    sceneCoordinator?.start()
  }
}
