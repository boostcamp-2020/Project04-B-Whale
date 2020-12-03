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
}
