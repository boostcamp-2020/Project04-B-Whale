//
//  SignInCoordinator.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/18.
//

import UIKit

final class SignInCoordinator: Coordinator {
  
  private var storyboard: UIStoryboard {
    return UIStoryboard.storyboard(storyboard: .signIn)
  }
  
  func start() -> UIViewController {
    // TODO:- SignInViewController의 init 수정 시 같이 수정해야함.
    guard let signInViewController = storyboard.instantiateInitialViewController() else {
      return UIViewController()
    }
    
    return signInViewController
  }
}
