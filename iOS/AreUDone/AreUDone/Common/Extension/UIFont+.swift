//
//  UIFont+.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/03.
//

import UIKit

extension UIFont {
  
  static func nanumB(size: CGFloat) -> UIFont {
    return UIFont(name: Font.nanumB.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
  }
  
  static func nanumR(size: CGFloat) -> UIFont {
    return UIFont(name: Font.nanumR.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
  }
}
