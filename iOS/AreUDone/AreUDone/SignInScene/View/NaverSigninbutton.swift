//
//  NaverSigninbutton.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/20.
//

import UIKit

class NaverSigninbutton: UIButton {
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  private func configure() {
    layer.cornerRadius = 5
    adjustsImageWhenHighlighted = false
  }
}
