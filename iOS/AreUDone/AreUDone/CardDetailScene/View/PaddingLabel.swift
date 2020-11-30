//
//  PaddingLabel.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/30.
//

import UIKit

class PaddingLabel: UILabel {
  
  private let topInset: CGFloat = 5.0
  private let bottomInset: CGFloat = 5.0
  private let leftInset: CGFloat = 8.0
  private let rightInset: CGFloat = 8.0

  override func drawText(in rect: CGRect) {
    let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)

    super.drawText(in: rect.inset(by: insets))
  }
  
  override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(width: size.width + leftInset + rightInset,
                  height: size.height + topInset + bottomInset)
  }
}
