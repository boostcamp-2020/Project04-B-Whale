//
//  SceneDelegate.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/18.
//

import NetworkFramework
import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  private var sceneCoordinator: Coordinator!
  
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    // TODO: 로그인 API 로부터 받은 AccessToken 저장
    sceneCoordinator.start()
  }
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
   
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    
    sceneCoordinator = SceneCoordinator(
      window: window, router: Router(),
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
