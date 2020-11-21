//
//  VideoPlayerLooper.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/20.
//

import AVKit
import Foundation

protocol VideoPlayerLoopable {
  func configureVideoLayer(for fileName: String, ofType type: String) -> AVPlayerLayer?
  func play()
  func remove()
}

final class VideoPlayerLooper: VideoPlayerLoopable {
  
  private var player: AVQueuePlayer!
  private var playerLayer: AVPlayerLayer?
  private var playerLooper: AVPlayerLooper?
  
  init(){
    configureNotification()
  }
  
  func configureVideoLayer(for fileName: String, ofType type: String) -> AVPlayerLayer? {
    if let path = Bundle.main.path(forResource: fileName, ofType: type) {
      let url = URL(fileURLWithPath: path)
      let playerItem = AVPlayerItem(url: url)
      
      player = AVQueuePlayer()
      try? AVAudioSession.sharedInstance().setCategory(.ambient)
      playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
      
      playerLayer = AVPlayerLayer(player: player)
      playerLayer?.videoGravity = .resizeAspectFill
      
      return playerLayer
    }
    
    return nil
  }
  
  func play() {
    player.play()
  }
  
  func pause() {
    player.pause()
  }
  
  func remove() {
    unload()
    playerLayer?.removeFromSuperlayer()
  }
  
  private func unload() {
    player = nil
    playerLayer = nil
    playerLooper = nil
  }
  
  private func configureNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(sceneWillEnterForeground), name: Notification.Name("fore"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(sceneDidEnterBackground), name: Notification.Name("back"), object: nil)
  }
  
  @objc private func sceneWillEnterForeground(){
    play()
  }
  
  @objc private func sceneDidEnterBackground(){
    pause()
  }
}
