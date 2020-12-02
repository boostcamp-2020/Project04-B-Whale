//
//  SideBarCollectionViewActivityCell.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/02.
//

import UIKit

final class SideBarCollectionViewActivityCell: UICollectionViewCell, Reusable {
  
  // MARK: - Property
  
  private lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    return titleLabel
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
  
  func update(with activity: Activity?) {
    guard let activity = activity else { return }
    titleLabel.text = activity.content
  }
}


// MARK: - Extension Configure Method

private extension SideBarCollectionViewActivityCell {
  
  func configure() {
    addSubview(titleLabel)
    
    configureTitle()
  }
  
  func configureTitle() {
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
}


