//
//  BorderLayer.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/16.
//

import UIKit

final class BorderLayer: CALayer {
  
  // MARK: - Initializer
  
  override init() {
    super.init()
  }
  
  override init(layer: Any) {
    super.init(layer: layer)
  }
  
  convenience init(frame: CGRect) {
    self.init()
    
    self.frame = frame
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("This class should be initialized with code")
  }
}


// MARK: - Extension Configure Method

extension BorderLayer {
  
  func configure() {
    backgroundColor = UIColor.clear.cgColor
    cornerRadius = frame.height / 22
  }
}

