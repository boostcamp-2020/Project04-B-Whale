//
//  InitCoordinatorFactory.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/18.
//

import Foundation

protocol CoordinatorFactoryable {
  func makeCoordinator(by isValid: SigninCheckResult) -> Coordinator
}

final class InitCoorndinatorFactory: CoordinatorFactoryable {
  
  func makeCoordinator(by isValid: SigninCheckResult) -> Coordinator {
    switch isValid {
    case .isLogin:
      return SigninCoordinator() // TODO: TabbarCoordinator 만들어주기
    case .isNotLogin:
      return SigninCoordinator()
    }
  }
}
