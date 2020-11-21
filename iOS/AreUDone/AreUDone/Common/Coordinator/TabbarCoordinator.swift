//
//  TabbarCoordinator.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/21.
//

import UIKit
import NetworkFramework


final class TabbarCoordinator: Coordinator {
  
  // MARK: - Property
  private let router: Router
  private let signInCoordinator: SigninCoordinator
  
  private let tabbarController: UITabBarController
  private let coordinators: [Coordinator]
  
  // MARK: - Initializer
  
  init(
    router: Router,
    signInCoordinator: SigninCoordinator,
    tabbarController: UITabBarController,
    coordinators: [Coordinator]
  ) {
    self.router = router
    self.signInCoordinator = signInCoordinator
    self.tabbarController = tabbarController
    self.coordinators = coordinators
  }
  
  
  // MARK: - Method
  
  func start() -> UIViewController {
    // 캘린더, 보드, 환경설정
    
    coordinators.enumerated().forEach { (index, coordinator) in
      configureController(with: coordinator)
      tabbarController.tabBarItem = UITabBarItem(title: "캘린더", image: UIImage(systemName: "circle"), tag: index)

    }
     
    return tabbarController
  }
  
  private func configureController(with coordinator: Coordinator) {
    
    let navigationController = UINavigationController()
    

    
    let viewController = coordinator.start()
    navigationController.pushViewController(viewController, animated: false)
    
    tabbarController.viewControllers?.append(navigationController)
  }
  
  
  
  
  
  
}
