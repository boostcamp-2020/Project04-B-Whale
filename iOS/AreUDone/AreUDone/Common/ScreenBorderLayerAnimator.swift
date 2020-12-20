//
//  ScreenBorderLayerAnimator.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/16.
//

import UIKit

final class AlertAnimator {
  
  // MARK: - Property
  
  let alertLayer: CALayer
  
  
  // MARK: - Initializer
  
  init(alertLayer: CALayer) {
    self.alertLayer = alertLayer
  }
  
  
  // MARK: - Method
  
  func start(networkState: Bool) {
    let color: CGColor

    if networkState { color = UIColor.systemGreen.cgColor
    } else { color = UIColor.systemRed.cgColor }
    alertLayer.backgroundColor = color

    let animation = CABasicAnimation(keyPath: "position.y")
    animation.fromValue = alertLayer.frame.origin.y
    animation.toValue = 0

    animation.duration = 4
    animation.autoreverses = true
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

    alertLayer.add(animation, forKey: "networkAlert")
  }
}
