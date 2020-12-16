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
    
    let widthAnimation = CABasicAnimation(keyPath: "borderWidth")
    widthAnimation.fromValue = 0
    widthAnimation.toValue = 9
    
    let colorAnimation = CABasicAnimation(keyPath: "borderColor")
    colorAnimation.fromValue = UIColor.systemOrange.cgColor
    colorAnimation.toValue = color
    
    let bothAnimations = CAAnimationGroup()
    bothAnimations.duration = 3
    bothAnimations.autoreverses = true
    bothAnimations.animations = [colorAnimation, widthAnimation]
    bothAnimations.timingFunction = CAMediaTimingFunction(
      name: CAMediaTimingFunctionName.easeInEaseOut
    )
    bothAnimations.repeatCount = 2
    bothAnimations.speed = 2
    borderLayer.add(bothAnimations, forKey: "networkAlert")
  }
}
