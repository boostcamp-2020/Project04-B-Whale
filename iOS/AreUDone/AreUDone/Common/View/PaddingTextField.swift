//
//  PaddingTextField.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/01.
//

import UIKit

final class PaddingTextField: UITextField {
  
  // MARK: - Property
  
  let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
  
  override public func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override public func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
}
