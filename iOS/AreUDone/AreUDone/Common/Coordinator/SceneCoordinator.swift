//
//  AppCoordinator.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/18.
//

import UIKit

final class SceneCoordinator: Coordinator {
  
  private var window: UIWindow?
  private let initCoordinator: Coordinator
  
  init(window: UIWindow, coordinator: Coordinator) {
    self.window = window
    initCoordinator = coordinator
  }
  
  func start() -> UIViewController {
    
    // SiginCoordinator or TabbarCoordinator
    let initViewController = initCoordinator.start()
    window?.rootViewController = initViewController
    window?.makeKeyAndVisible()
    
    return initViewController
  }
}
