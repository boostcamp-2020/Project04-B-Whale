//
//  SignInCoordinator.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/18.
//

import UIKit
import NetworkFramework

final class SigninCoordinator: Coordinator {
  
  private var storyboard: UIStoryboard {
    return UIStoryboard.storyboard(storyboard: .signin)
  }
  
  func start() -> UIViewController {
    // TODO:- SignInViewController의 init 수정 시 같이 수정해야함.
    
    let signInViewController = storyboard.instantiateViewController(
      identifier: "SignInViewController",
      creator: { coder in
        let viewModel = SigninViewModel()
        return SigninViewController(coder: coder, viewModel: viewModel)
      })
    
    return signInViewController
  }
}

extension SigninCoordinator {
  func openURL() {
    guard let url = URL(string: "") else { return }
    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
    }
  }
}
