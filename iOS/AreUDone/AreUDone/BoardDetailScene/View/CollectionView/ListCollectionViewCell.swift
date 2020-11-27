//
//  ListCollectionViewCell.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import UIKit

final class ListCollectionViewCell: UICollectionViewCell, Reusable {
  
  // MARK: - Property
  
  private let titleLabel = UILabel()
  
  
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
  
  private func configure() {
    addSubview(titleLabel)
    
    configureTitle()
  }
  
  private func configureTitle() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  func update(with card: Card) {
    titleLabel.text = card.title
  }
}
