//
//  CardAddTableView.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/10.
//

import UIKit

final class CardAddTableView: UITableView {
  
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

private extension CardAddTableView {
  
  func configure() {
    
    configureView()
  }
  
  func configureView() {
    backgroundColor = color
    rowHeight = height
    
    registerCell()
  }
  
  func registerCell() {
    register(TitleTableViewCell.self)
    register(CardAddCalendarTableViewCell.self)
  }
}



