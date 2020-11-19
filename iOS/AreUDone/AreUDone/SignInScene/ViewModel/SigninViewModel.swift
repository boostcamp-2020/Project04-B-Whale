//
//  SigninViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/18.
//

import Foundation

protocol SigninViewModelProtocol {
  
  func naverSigninBinding(handler: @escaping (() -> ()))
  func appleSigninBinding(handler: @escaping (() -> ()))
  
  func naverSigninButtonTapped()
  func appleSigninButtonTapped()
}

final class SigninViewModel: SigninViewModelProtocol {
  
  private var naverSigninHandler: (() -> ())?
  private var appleSigninHandler: (() -> ())?
  
  func naverSigninBinding(handler: @escaping (() -> ())) {
    naverSigninHandler = handler
  }
  
  func appleSigninBinding(handler: @escaping (() -> ())) {
    appleSigninHandler = handler
  }
  
  func naverSigninButtonTapped() {
    // TODO: 네트워크 Service 객체에 네이버 로그인 요청
    
//    naverSignInHandler
  }
  
  func appleSigninButtonTapped() {
    // TODO: 네트워크 Service 객체에 애플 로그인 요청
//    appleSignInHandler
  }
}
