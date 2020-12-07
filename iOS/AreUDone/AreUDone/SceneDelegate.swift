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
    guard
      let url = URLContexts.first?.url,
      url.absoluteString.starts(with: "areudoneios://"),
      let token = url.absoluteString.split(separator: "=").last.map({ String($0) }),
      let decodedToken = token.removingPercentEncoding
    else { return }

    Keychain.shared.save(value: decodedToken, forKey: "token")
    
    sceneCoordinator.start()
  }
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
   
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    
//    Keychain.shared.removeValue(forKey: "token") // TODO:- 테스트용 코드
    
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
    NotificationCenter.default.post(name: Notification.Name("fore"), object: nil)
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    NotificationCenter.default.post(name: Notification.Name("back"), object: nil)
  }
  
  
}
