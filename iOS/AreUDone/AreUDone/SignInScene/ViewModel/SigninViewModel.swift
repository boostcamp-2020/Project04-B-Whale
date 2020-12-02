//
//  SigninViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/18.
//

import AVFoundation
import Foundation
import NetworkFramework

protocol SigninViewModelProtocol {
  
  func naverSigninBinding(handler: @escaping ((EndPointable) -> Void))
  func appleSigninBinding(handler: @escaping ((EndPointable) -> Void))
  func videoPlayBinding(handler: @escaping((AVPlayerLayer) -> Void))
  
  func naverSigninButtonTapped()
  func appleSigninButtonTapped()
  func videoPlay()
  func videoRemove()
}

final class SigninViewModel: SigninViewModelProtocol {

  // MARK: - Property
  
  private var naverSigninHandler: ((EndPointable) -> Void)?
  private var appleSigninHandler: ((EndPointable) -> Void)?
  private var videoPlayHandler: ((AVPlayerLayer) -> Void)?
  private var videoPlayerLooper: VideoPlayerLoopable?
  
  
  // MARK: - Initializer
  
  init(videoPlayerLooper: VideoPlayerLoopable) {
    self.videoPlayerLooper = videoPlayerLooper
  }
  
  
  // MARK: - Method
  
  func naverSigninBinding(handler: @escaping ((EndPointable) -> Void)) {
    naverSigninHandler = handler

  }
  
  func appleSigninBinding(handler: @escaping ((EndPointable) -> Void)) {
    appleSigninHandler = handler
  }
  
  func videoPlayBinding(handler: @escaping ((AVPlayerLayer) -> Void)) {
    videoPlayHandler = handler
  }
  
  func naverSigninButtonTapped() {
    // TODO: 네트워크 Service 객체에 네이버 로그인 요청
    
  }
  
  func appleSigninButtonTapped() {
    // TODO: 네트워크 Service 객체에 애플 로그인 요청

  }
  
  func videoPlay() {
    if let playerLayer = videoPlayerLooper?.configureVideoLayer(
        for: VideoConstant.background,
        ofType: VideoConstant.mp4
    ) {
      videoPlayHandler?(playerLayer)
      videoPlayerLooper?.play()
    }
  }
  
  func videoRemove() {
    videoPlayerLooper?.remove()
    videoPlayerLooper = nil
  }
}
