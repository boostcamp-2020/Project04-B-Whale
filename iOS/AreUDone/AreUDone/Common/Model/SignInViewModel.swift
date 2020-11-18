//
//  SignInViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/18.
//

import Foundation

protocol SignInViewModelProtocol {
  
  func naverSignInBinding(handler: @escaping (() -> ()))
  func appleSignInBinding(handler: @escaping (() -> ()))
  
  func naverSignInButtonTapped()
  func appleSignInButtonTapped()
}

final class SignInViewModel: SignInViewModelProtocol {
  
  private var naverSignInHandler: (() -> ())?
  private var appleSignInHandler: (() -> ())?
  
  func naverSignInBinding(handler: @escaping (() -> ())) {
    naverSignInHandler = handler
  }
  
  func appleSignInBinding(handler: @escaping (() -> ())) {
    appleSignInHandler = handler
  }
  
  func naverSignInButtonTapped() {
    // TODO: 네트워크 Service 객체에 네이버 로그인 요청
    
//    naverSignInHandler
  }
  
  func appleSignInButtonTapped() {
    // TODO: 네트워크 Service 객체에 애플 로그인 요청
//    appleSignInHandler
  }
}
