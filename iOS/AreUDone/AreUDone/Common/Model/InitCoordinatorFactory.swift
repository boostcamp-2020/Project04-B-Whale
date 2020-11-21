//
//  InitCoordinatorFactory.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/18.
//

import UIKit
import NetworkFramework

protocol CoordinatorFactoryable {
  func coordinator(by isValid: SigninCheckResult, with router: Routable) -> Coordinator
}

final class InitCoorndinatorFactory: CoordinatorFactoryable {
  
  func coordinator(by result: SigninCheckResult, with router: Routable) -> Coordinator {
    switch result {
    case .isSigned:
      let coordinators = [CalendarCoordinator()]
      return TabbarCoordinator(
        router: router,
        signInCoordinator: SigninCoordinator(),
        tabbarController: UITabBarController(),
        coordinators: coordinators
      )
    case .isNotSigned:
      return SigninCoordinator()
    }
  }
}
