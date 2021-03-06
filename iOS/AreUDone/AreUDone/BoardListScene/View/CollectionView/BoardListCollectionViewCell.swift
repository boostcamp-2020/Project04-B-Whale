//
//  BoardListCollectionViewCell.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import UIKit

final class BoardListCollectionViewCell: UICollectionViewCell, Reusable {
  
  // MARK: - Property
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.nanumR(size: 18)
    
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
  
  func update(with board: Board) {
    titleLabel.text = board.title
    backgroundColor = board.color.toUIColor().withAlphaComponent(0.5)
  }
}


// MARK:- Extension Configure Method

private extension BoardListCollectionViewCell {
  
  func configure() {
    addSubview(titleLabel)
    
    configureView()
    configureTitleLabel()
  }
  
  func configureView() {
    layer.cornerRadius = 10
  }
  
  func configureTitleLabel() {
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
}
