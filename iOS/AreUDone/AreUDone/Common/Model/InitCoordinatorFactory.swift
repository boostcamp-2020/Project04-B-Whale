//
//  InitCoordinatorFactory.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/18.
//

import Foundation

protocol CoordinatorFactoryable {
  func makeCoordinator(by isValid: Bool) -> Coordinator
}

final class InitCoorndinatorFactory: CoordinatorFactoryable {
  
  func makeCoordinator(by isValid: Bool) -> Coordinator {
    switch isValid {
    case true:
      print("탭바")
      return SigninCoordinator() // TODO: TabbarCoordinator 만들어주기
    case false:
      return SigninCoordinator()
    }
  }
}
