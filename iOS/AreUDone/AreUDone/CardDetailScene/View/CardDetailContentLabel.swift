//
//  CardDetailContentLabel.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/30.
//

import UIKit

class CardDetailContentLabel: PaddingLabel {
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  private func configure() {
    layer.borderWidth = 0.5
    layer.borderColor = UIColor.lightGray.cgColor
    layer.cornerRadius = 2
    numberOfLines = 0
    lineBreakMode = .byWordWrapping
    font = UIFont(name: "AmericanTypewriter-Condensed", size: 15)
    backgroundColor = .white
    
    
    configureShadow()
  }
  
  private func configureShadow() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: bounds.width + 3, height: bounds.height + 3)
    layer.masksToBounds = false
    layer.shadowRadius = 2
    layer.shadowOffset = .zero
    layer.shadowOpacity = 0.6
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
}
