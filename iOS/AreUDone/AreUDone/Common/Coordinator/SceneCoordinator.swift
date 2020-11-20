//
//  AppCoordinator.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/18.
//

import UIKit

final class SceneCoordinator: Coordinator {
  
  // MARK: - Property
  
  private var window: UIWindow?
  private let initCoordinatorFactory: CoordinatorFactoryable
  private let signinChecker: SigninCheckable
  
  
  // MARK: - Initializer
  
  init(
    window: UIWindow?,
    factory: CoordinatorFactoryable,
    signinChecker: SigninCheckable
  ) {
    self.window = window
    initCoordinatorFactory = factory
    self.signinChecker = signinChecker
  }
  
  
  // MARK: - Method
  
  @discardableResult
  func start() -> UIViewController {
    let signinCheckResult = signinChecker.check()
    
    let initCoordinator = initCoordinatorFactory.makeCoordinator(by: signinCheckResult)
    let initViewController = initCoordinator.start()
    window?.rootViewController = initViewController
    window?.makeKeyAndVisible()
    
    return initViewController
  }
}
