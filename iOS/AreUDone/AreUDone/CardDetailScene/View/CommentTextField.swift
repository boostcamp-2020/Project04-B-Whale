//
//  CommentTextField.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/30.
//

import UIKit

final class CommentTextField: UITextField {
  
  // MARK:- Property
  
  private let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
  
  
  // MARK:- Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  
  // MARK:- Method
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
}


// MARK:- Extension Configure Method

private extension CommentTextField {
  
  func configure() {
    placeholder = "댓글을 입력하세요..."
    layer.borderWidth = 0.6
    layer.borderColor = UIColor.black.cgColor
    layer.cornerRadius = 3
  }
}
