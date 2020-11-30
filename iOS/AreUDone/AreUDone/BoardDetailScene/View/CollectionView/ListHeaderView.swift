//
//  ListHeaderView.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/29.
//

import UIKit

final class ListHeaderView: UICollectionReusableView, Reusable {
  
  // MARK: - Property
  
  let titleLabel = UILabel()
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    titleLabel.text = "TODO"
    backgroundColor = #colorLiteral(red: 0.944453299, green: 0.9647708535, blue: 0.9688996673, alpha: 0.745906464)
    configure()
  }
  
  
  // MARK: - Method
  
  private func configure() {
    addSubview(titleLabel)
    
    configureTitle()
    
    layer.cornerRadius = 5
    
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 1)
    layer.shadowRadius = 0.4
    layer.shadowOpacity = 0.3
  }
  
  func configureTitle() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30)
    ])
  }
}

