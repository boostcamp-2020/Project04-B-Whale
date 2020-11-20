//
//  SigninViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/18.
//

import Foundation
import NetworkFramework

protocol SigninViewModelProtocol {
  
  func naverSigninBinding(handler: @escaping ((EndPointable) -> ()))
  func appleSigninBinding(handler: @escaping ((EndPointable) -> ()))
  func videoPlayBinding(handler: @escaping((VideoPlayerLooper) -> Void))
  
  func naverSigninButtonTapped()
  func appleSigninButtonTapped()
  func videoPlay()
  func videoRemove()
}

final class SigninViewModel: SigninViewModelProtocol {
  
  private var naverSigninHandler: ((EndPointable) -> ())?
  private var appleSigninHandler: ((EndPointable) -> ())?
  private var videoPlayHandler: ((VideoPlayerLooper) -> Void)?
  
  private var videoPlayerLooper = VideoPlayerLooper()
  
  func naverSigninBinding(handler: @escaping ((EndPointable) -> ())) {
    naverSigninHandler = handler

  }
  
  func appleSigninBinding(handler: @escaping ((EndPointable) -> ())) {
    appleSigninHandler = handler
  }
  
  func videoPlayBinding(handler: @escaping ((VideoPlayerLooper) -> Void)) {
    videoPlayHandler = handler
  }
  
  func naverSigninButtonTapped() {
    // TODO: 네트워크 Service 객체에 네이버 로그인 요청
    

  }
  
  func appleSigninButtonTapped() {
    // TODO: 네트워크 Service 객체에 애플 로그인 요청

  }
  
  func videoPlay() {
    videoPlayHandler?(videoPlayerLooper)
    videoPlayerLooper.play()
  }
  
  func videoRemove() {
    videoPlayerLooper.remove()
  }
}
