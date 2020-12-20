//
//  SceneDelegate.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/18.
//

import NetworkFramework
import UIKit
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  // MARK: - Property
  
  var window: UIWindow?
  
  private var sceneCoordinator: Coordinator!
  private var isInitialNotification = true
  private lazy var screenBorderAlertAnimator = ScreenBorderAlertAnimator(
    borderLayer: borderLayer
  )
  private lazy var borderLayer: BorderLayer = {
    let rootView = window?.rootViewController?.view
    let frame = rootView?.frame ?? .zero
    
    let borderLayer = BorderLayer(frame: frame)
    rootView?.layer.addSublayer(borderLayer)
    return borderLayer
  }()
  
  
  // MARK: - Method
  
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    signIn(by: URLContexts)
  }
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    let router = Router()
    
    //    Keychain.shared.removeValue(forKey: "token") // TODO:- 테스트용 코드
    
    configureSceneCoordinator(
      router: router,
      window: window ?? UIWindow(windowScene: windowScene)
    )
    configureNetworkMonitor(router: router)
    configureNotification()
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


// MARK: - Extension Configure Method

private extension SceneDelegate {
  
  func configureSceneCoordinator(router: Routable, window: UIWindow) {
    sceneCoordinator = SceneCoordinator(
      window: window, router: router,
      factory: InitCoorndinatorFactory(),
      signinChecker: SigninChecker()
    )
    sceneCoordinator.start()
  }
  
  func configureNetworkMonitor(router: Routable) {
    let monitor = NWMonitor(router: router)
    monitor.start()
  }
  
  func configureNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(networkChanged),
      name: Notification.Name.networkChanged,
      object: nil
    )
  }
}

// MARK: - Extension

private extension SceneDelegate {
  
  func signIn(by URLContexts: Set<UIOpenURLContext>) {
    guard
      let url = URLContexts.first?.url,
      url.absoluteString.starts(with: "areudoneios://"),
      let token = url.absoluteString.split(separator: "=").last.map({ String($0) }),
      let decodedToken = token.removingPercentEncoding
    else { return }
    
    let tokenParser = TokenParser()
    let items = tokenParser.decode(jwtToken: decodedToken)
    
    Keychain.shared.save(value: decodedToken, forKey: "token")
    UserIdStore.saveUserId(with: items)
    
    sceneCoordinator.start()
  }
}


// MARK: - Extension objc Method

extension SceneDelegate {
  
  @objc func networkChanged(notification: Notification) {
    DispatchQueue.main.async {
      guard
        let networkState = notification.userInfo?["networkState"] as? Bool, !self.isInitialNotification
      else {
        self.isInitialNotification = false
        return
      }
      
      self.screenBorderAlertAnimator.start(networkState: networkState)
    }
  }
}
