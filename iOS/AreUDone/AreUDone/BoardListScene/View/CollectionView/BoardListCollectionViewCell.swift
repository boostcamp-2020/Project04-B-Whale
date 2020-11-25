//
//  BoardListCollectionViewCell.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import UIKit

final class BoardListCollectionViewCell: UICollectionViewCell, Reusable {
  
  // MARK: - Property
  
  private let title = UILabel()
  
  
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
    addSubview(title)
    title.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      title.centerXAnchor.constraint(equalTo: centerXAnchor),
      title.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  func updateCell(board: Board) {
    title.text = board.title
  }
}
