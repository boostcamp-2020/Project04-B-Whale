//
//  UIScrollView+.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/15.
//

import UIKit

extension UIScrollView {
  func scrollToBottom() {
    if contentSize.height > bounds.height {
      let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
      setContentOffset(bottomOffset, animated: true)
    }
  }
  
  func scrollToTop(for point: CGPoint) {
    let topOffset = point
    setContentOffset(topOffset, animated: true)
  }
}
