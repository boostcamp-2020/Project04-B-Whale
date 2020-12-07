//
//  BoardAddTableView.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/07.
//

import UIKit

final class BoardAddTableView: UITableView {
  
  // MARK: - Property
  
  private let height: CGFloat = 50
  private let color: UIColor = .systemGray5
  
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: .grouped)
    
    configure()
  }
}


// MARK: - Extension Configure Method

private extension BoardAddTableView {
  
  func configure() {
    backgroundColor = color
    
    rowHeight = height
    register(BoardTitleTableViewCell.self)
    register(BoardColorTableViewCell.self)
  }
}
