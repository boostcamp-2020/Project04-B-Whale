//
//  CommentTableView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/26.
//

import UIKit

final class CommentTableView: UITableView {

  // MARK:- Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    
    configure()
  }
  
  
  // MARK:- Method
  
  private func configure() {
    showsVerticalScrollIndicator = false
    showsHorizontalScrollIndicator = false
    separatorStyle = .none
    
    registerCell()
  }
  
  private func registerCell() {
    register(CommentTableViewCell.self)
  }
}
