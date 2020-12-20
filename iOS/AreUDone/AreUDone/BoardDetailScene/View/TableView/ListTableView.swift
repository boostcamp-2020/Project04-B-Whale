//
//  ListTableView.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/15.
//

import UIKit

final class ListTableView: UITableView {
  
  // MARK:- Initializer
  
  required init?(coder: NSCoder) {
    fatalError("This class Should be initialized with code")
  }
  
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    
    configure()
  }
}


// MARK:- Extension Configure Method

private extension ListTableView {
  
  func configure() {
    
    configureView()
    registerCell()
  }
  
  func configureView() {
    backgroundColor = .clear

    rowHeight = 65
    sectionHeaderHeight = 60
    sectionFooterHeight = 60
    
    showsVerticalScrollIndicator = false
    allowsMultipleSelection = false
  }
  
  func registerCell() {
    register(ListTableViewCell.self)
  }
}

