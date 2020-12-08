//
//  MemberTableView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/07.
//

import UIKit

final class MemberTableView: UITableView {

  // MARK:- Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    
    configure()
  }
}

private extension MemberTableView {
  
  func configure() {
    registerCell()
  }
  
  func registerCell() {
    register(MemberTableViewCell.self)
  }
}
