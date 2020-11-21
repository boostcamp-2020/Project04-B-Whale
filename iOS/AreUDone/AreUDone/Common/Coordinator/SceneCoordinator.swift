//
//  AppCoordinator.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/18.
//

import NetworkFramework
import UIKit

final class SceneCoordinator: Coordinator {
  
  private var window: UIWindow?
  private let initCoordinatorFactory: CoordinatorFactoryable
  private let signinChecker: SigninCheckable
  private let router: Router
  
  init(
    window: UIWindow?,
    router: Router,
    factory: CoordinatorFactoryable,
    signinChecker: SigninCheckable
  ) {
    self.window = window
    self.router = router
    initCoordinatorFactory = factory
    self.signinChecker = signinChecker
  }
  
  @discardableResult
  func start() -> UIViewController {
    let signinCheckResult = signinChecker.check()
    
    let initCoordinator = initCoordinatorFactory.coordinator(
      by: .isLogin,
      with: router
    )
    let initViewController = initCoordinator.start()
    window?.rootViewController = initViewController
    window?.makeKeyAndVisible()
    
    return initViewController
  }
}
