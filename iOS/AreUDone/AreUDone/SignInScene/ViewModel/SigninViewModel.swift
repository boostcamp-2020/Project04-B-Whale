//
//  SigninViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/18.
//

import Foundation
import NetworkFramework

protocol SigninViewModelProtocol {
  
  func naverSigninBinding(handler: @escaping ((EndPointable) -> Void))
  func appleSigninBinding(handler: @escaping ((EndPointable) -> Void))
  
  func naverSigninButtonTapped()
  func appleSigninButtonTapped()
}

final class SigninViewModel: SigninViewModelProtocol {
  
  // MARK: - Property
  
  private var naverSigninHandler: ((EndPointable) -> Void)?
  private var appleSigninHandler: ((EndPointable) -> Void)?
  
  
  // MARK: - Method
  
  func naverSigninBinding(handler: @escaping ((EndPointable) -> Void)) {
    naverSigninHandler = handler

  }
  
  func appleSigninBinding(handler: @escaping ((EndPointable) -> Void)) {
    appleSigninHandler = handler
  }
  
  func naverSigninButtonTapped() {
    // TODO: 네트워크 Service 객체에 네이버 로그인 요청
    
  }
  
  func appleSigninButtonTapped() {
    // TODO: 네트워크 Service 객체에 애플 로그인 요청

  }
}
