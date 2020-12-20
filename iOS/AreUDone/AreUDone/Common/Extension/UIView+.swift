//
//  UIView+.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/03.
//

import UIKit

extension UIView {
  
  static func dividerView() -> UIView {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    view.backgroundColor = .lightGray
    
    return view
  }
  
  func addShadow(
    color: CGColor = UIColor.black.cgColor,
    offset: CGSize,
    radius: CGFloat,
    opacity: Float
  ) {
    self.layer.shadowColor = color
    self.layer.shadowOffset = offset
    self.layer.shadowRadius = radius
    self.layer.shadowOpacity = opacity
  }
}
