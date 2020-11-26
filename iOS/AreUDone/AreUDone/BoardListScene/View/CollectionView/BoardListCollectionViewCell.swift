//
//  BoardListCollectionViewCell.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import UIKit

final class BoardListCollectionViewCell: UICollectionViewCell, Reusable {
  
  // MARK: - Property
  
  private let titleLabel = UILabel()
  
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .gray
    configure()
  }
  
  
  // MARK: - Method
  
  private func configure() {
    configureTitle()
  }
  
  private func configureTitle() {
    addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  func updateCell(board: Board) {
    titleLabel.text = board.title
  }
}
