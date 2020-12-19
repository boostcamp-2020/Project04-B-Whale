//
//  ScreenBorderLayerAnimator.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/16.
//

import UIKit

final class ScreenBorderAlertAnimator {
  
  // MARK: - Property
  
  let borderLayer: CALayer
  
  
  // MARK: - Initializer
  
  init(borderLayer: CALayer) {
    self.borderLayer = borderLayer
  }
  
  
  // MARK: - Method
  
  func start(networkState: Bool) {
    let color: CGColor

    if networkState { color = UIColor.systemGreen.cgColor
    } else { color = UIColor.systemRed.cgColor }
    borderLayer.backgroundColor = color

    let animation = CABasicAnimation(keyPath: "position.y")
    animation.fromValue = borderLayer.frame.origin.y
    animation.toValue = 0

    animation.duration = 4
    animation.autoreverses = true
    animation.timingFunction = CAMediaTimingFunction(
      name: CAMediaTimingFunctionName.easeInEaseOut
    )

    borderLayer.add(animation, forKey: "networkAlert")
  }
}
