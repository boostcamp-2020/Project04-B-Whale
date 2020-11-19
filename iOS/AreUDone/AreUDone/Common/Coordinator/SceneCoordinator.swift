//
//  AppCoordinator.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/18.
//

import UIKit

final class SceneCoordinator: Coordinator {
  
  private var window: UIWindow?
  private let initCoordinatorFactory: CoordinatorFactoryable
  
  init(window: UIWindow, factory: CoordinatorFactoryable) {
    self.window = window
    initCoordinatorFactory = factory
  }
  
  @discardableResult
  func start() -> UIViewController {
    let isSignIn = checkSignIn()
    
    let initCoordinator = initCoordinatorFactory.makeCoordinator(by: isSignIn)
    let initViewController = initCoordinator.start()
    window?.rootViewController = initViewController
    window?.makeKeyAndVisible()
    
    return initViewController
  }
  
  private func checkSignIn() -> Bool {
    if let _ = Keychain.shared.loadValue(forKey: "") {
      return true
    }
    return false
  }
}
