//
//  SceneDelegate.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/18.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
   
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    
    let sceneCoordinator = SceneCoordinator(
      window: window,
      factory: InitCoorndinatorFactory(),
      signinChecker: SigninChecker()
    )
    sceneCoordinator.start()
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {
  
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
   
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
   
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
   
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    
  }
  
  
}
