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
  
  func videoPlayBinding(handler: @escaping((AVPlayerLayer) -> Void))
  
  func videoPlay()
  func videoRemove()
}

final class SigninViewModel: SigninViewModelProtocol {

  // MARK: - Property
  
  private var videoPlayHandler: ((AVPlayerLayer) -> Void)?
  private var videoPlayerLooper: VideoPlayerLoopable?
  
  
  // MARK: - Initializer
  
  init(videoPlayerLooper: VideoPlayerLoopable) {
    self.videoPlayerLooper = videoPlayerLooper
  }
  
  
  // MARK: - Method
  
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


// MARK:- Extension BindUI

extension SigninViewModel {
  
  func videoPlayBinding(handler: @escaping ((AVPlayerLayer) -> Void)) {
    videoPlayHandler = handler
  }
}
