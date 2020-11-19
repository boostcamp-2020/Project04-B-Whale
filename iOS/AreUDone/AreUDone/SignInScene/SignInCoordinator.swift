//
//  SignInCoordinator.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/18.
//

import UIKit
import NetworkFramework



final class SignInCoordinator: Coordinator {
  
  private var storyboard: UIStoryboard {
    return UIStoryboard.storyboard(storyboard: .signIn)
  }
  
  func start() -> UIViewController {
    // TODO:- SignInViewController의 init 수정 시 같이 수정해야함.
    
    let signInViewController = storyboard.instantiateViewController(
      identifier: "SignInViewController",
      creator: { coder in
        let viewModel = SignInViewModel()
        return SignInViewController(coder: coder, viewModel: viewModel)
      })
    
    return signInViewController
  }
}
