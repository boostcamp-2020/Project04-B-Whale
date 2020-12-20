//
//  SettingTableView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/15.
//

import UIKit

final class SettingTableView: UITableView {
  
  // MARK:- Initializer
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    
    configure()
  }
}


// MARK:- Extension Configure Method

private extension SettingTableView {
  
  func configure() {
    allowsMultipleSelection = false
    
    registerCell()
  }
  
  func registerCell() {
    register(SettingTableViewCell.self)
  }
}
