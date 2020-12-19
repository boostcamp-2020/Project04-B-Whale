//
//  AppCoordinator.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/18.
//

import NetworkFramework
import UIKit

final class SceneCoordinator: Coordinator {
  
  // MARK: - Property
  
  weak var parentCoordinator: Coordinator?
  private var initCoordinator: Coordinator!
  
  private var window: UIWindow?
  private let router: Routable
  private let initCoordinatorFactory: CoordinatorFactoryable
  private let signinChecker: SigninCheckable
  
  
  // MARK: - Initializer
  
  init(
    window: UIWindow?,
    router: Routable,
    factory: CoordinatorFactoryable,
    signinChecker: SigninCheckable
  ) {
    self.window = window
    self.router = router
    self.initCoordinatorFactory = factory
    self.signinChecker = signinChecker
  }
  
  
  // MARK: - Method
  
  func start() -> UIViewController {
    let signinCheckResult = signinChecker.check()
    
    initCoordinator = initCoordinatorFactory.coordinator(
      by: signinCheckResult,
      with: router
    )
    initCoordinator.parentCoordinator = self
    
    let initViewController = initCoordinator.start()
    window?.rootViewController = initViewController
    window?.makeKeyAndVisible()
    
    return initViewController
  }
}
