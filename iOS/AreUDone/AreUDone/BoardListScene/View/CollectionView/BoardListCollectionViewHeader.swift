//
//  BoardListCollectionViewHeader.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import UIKit

final class BoardListCollectionViewHeader: UICollectionReusableView, Reusable {
  
  // MARK: - Property
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.nanumB(size: 20)
    
    return label
  }()
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  
  // MARK: - Method
  
  func update(with title: String) {
    titleLabel.text = title
  }
}


// MARK:- Extension 

private extension BoardListCollectionViewHeader {
  
  func configure() {
    addSubview(titleLabel)
    
    configureTitleLabel()
  }
  
  func configureTitleLabel() {
    NSLayoutConstraint.activate([
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30)
    ])
  }
}
