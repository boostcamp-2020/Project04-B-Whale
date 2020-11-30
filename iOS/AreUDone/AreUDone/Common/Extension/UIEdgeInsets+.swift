//
//  UIEdgeInsets+.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/29.
//

import UIKit

extension UIEdgeInsets {
  
  static func sameInset(inset: CGFloat) -> Self {
    .init(
      top: inset,
      left: inset,
      bottom: inset,
      right: inset
    )
  }
}
