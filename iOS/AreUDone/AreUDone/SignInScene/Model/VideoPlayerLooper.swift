//
//  VideoPlayerLooper.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/20.
//

import AVKit
import Foundation

class VideoPlayerLooper {
  
  private var player: AVQueuePlayer!
  private var playerLayer: AVPlayerLayer?
  private var playerLooper: AVPlayerLooper?
  
  func configureVideoLayer(for fileName: String, ofType type: String) -> AVPlayerLayer? {
    if let path = Bundle.main.path(forResource: fileName, ofType: type) {
      let url = URL(fileURLWithPath: path)
      let playerItem = AVPlayerItem(url: url)
      
      player = AVQueuePlayer()
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
  
  func remove() {
    unload()
    playerLayer?.removeFromSuperlayer()
  }
  
  func unload() {
    player = nil
    playerLayer = nil
    playerLooper = nil
  }
}
