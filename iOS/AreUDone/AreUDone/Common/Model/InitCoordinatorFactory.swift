//
//  InitCoordinatorFactory.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/18.
//

import UIKit
import NetworkFramework

protocol CoordinatorFactoryable {
  func coordinator(by isValid: SigninCheckResult, with router: Router) -> Coordinator
}

final class InitCoorndinatorFactory: CoordinatorFactoryable {
  
  func coordinator(by isValid: SigninCheckResult, with router: Router) -> Coordinator {
    switch isValid {
    case .isLogin:
      let coordinators = [CalendarCoordinator()]
      return TabbarCoordinator(
        router: router,
        signInCoordinator: SigninCoordinator(),
        tabbarController: UITabBarController(),
        coordinators: coordinators
      )
    case .isNotLogin:
      return SigninCoordinator()
    }
  }
}
