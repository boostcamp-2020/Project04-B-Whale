//
//  EmptyIndicatorView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/16.
//

import UIKit

enum EmptyType {
  case cardEmpty
  case boardEmpty
  case commentEmpty
  
  var emptyIndicatorText: String {
    switch self {
    case .cardEmpty:
      return "보드에서 카드를 생성해보세요🔖🗂"
      
    case .boardEmpty:
      return "보드를 생성해보세요📝"
      
    case .commentEmpty:
      return "첫 번째 댓글을 달아주세요😭"
    }
  }
}

final class EmptyIndicatorView: UIView {

  // MARK:- Property
  
  private lazy var emptyIndicatorLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.font = UIFont.nanumB(size: 20)
    
    return label
  }()
  
  
  convenience init(emptyType: EmptyType) {
    self.init()
    
    emptyIndicatorLabel.text = emptyType.emptyIndicatorText
    configure()
  }
}


// MARK:- Extension Configure Method

private extension EmptyIndicatorView {
  
  func configure() {
    isHidden = true
    addSubview(emptyIndicatorLabel)
    
    configureEmptyIndicatorLabel()
  }
  
  func configureEmptyIndicatorLabel() {
    NSLayoutConstraint.activate([
      emptyIndicatorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      emptyIndicatorLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
}
