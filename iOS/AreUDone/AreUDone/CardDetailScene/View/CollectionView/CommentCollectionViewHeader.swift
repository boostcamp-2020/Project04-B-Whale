//
//  CommentCollectionViewHeader.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/30.
//

import UIKit

final class CommentCollectionViewHeader: UICollectionReusableView, Reusable {
  
  
  private lazy var headerLabel: UILabel = {
    let label = UILabel()
    label.text = "댓글"
    label.font = UIFont.nanumB(size: 20)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
}


private extension CommentCollectionViewHeader {
  
  func configure() {
    addSubview(headerLabel)
    
    configureHeaderLabel()
  }
  
  func configureHeaderLabel() {
    NSLayoutConstraint.activate([
      headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
      headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      headerLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
    ])
  }
}
