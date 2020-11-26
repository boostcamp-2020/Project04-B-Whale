//
//  BoardListCollectionViewHeader.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import UIKit

final class BoardListCollectionViewHeader: UICollectionReusableView, Reusable {
  
  // MARK: - Property
  
  let titleLabel = UILabel()
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    titleLabel.text = "샘플입니다"
    configure()
  }
  
  
  // MARK: - Method
  
  private func configure() {
    configureTitle()
  }
  
  func configureTitle() {
    addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30)
    ])
    
    
    
    
  }
  
  
  
}
