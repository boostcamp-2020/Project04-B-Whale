//
//  SettingCoordinator.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/15.
//

import UIKit

final class SettingCoordinator: NavigationCoordinator {
  
  // MARK:- Property
  
  private var storyboard: UIStoryboard {
    return UIStoryboard.load(storyboard: .signin)
  }
  
  var navigationController: UINavigationController?
  
  
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
