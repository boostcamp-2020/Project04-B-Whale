//
//  SideBarCollectionViewActivityCell.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/02.
//

import UIKit

final class SideBarCollectionViewActivityCell: UICollectionViewCell, Reusable {
  
  // MARK: - Property
  
  private lazy var contentLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.font = UIFont.nanumB(size: 18)
    label.numberOfLines = 0

    return label
  }()
  
  private lazy var createdAtLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.font = UIFont.nanumR(size: 12)
    
    return label
  }()
  
  private lazy var width: NSLayoutConstraint = {
      let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
      width.isActive = true
      return width
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
  
  override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
    width.constant = bounds.size.width
    return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 0))
  }
  
  func update(with activity: Activity?) {
    guard let activity = activity else { return }
    contentLabel.text = activity.content
    createdAtLabel.text = activity.createdAt
  }
}


// MARK: - Extension Configure Method

private extension SideBarCollectionViewActivityCell {
  
  func configure() {
    contentView.addSubview(contentLabel)
    contentView.addSubview(createdAtLabel)
    
    configureContentView()
    configureContentLabel()
    configureCreatedAtLabel()
  }
  
  func configureContentView() {
    contentView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureContentLabel() {
    NSLayoutConstraint.activate([
      contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      contentLabel.bottomAnchor.constraint(equalTo: createdAtLabel.topAnchor, constant: -7),
      contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
    ])
  }
  
  func configureCreatedAtLabel() {
    NSLayoutConstraint.activate([
      createdAtLabel.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor, constant: 5),
      createdAtLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
    ])
  }
}
