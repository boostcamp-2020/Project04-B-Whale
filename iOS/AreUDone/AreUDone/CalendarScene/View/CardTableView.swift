//
//  CardTableView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/23.
//

import UIKit

final class CardTableView: UITableView {

  // MARK:- Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: .grouped)
    
    configure()
  }

  
  // MARK:- Initializer
  
  private func configure() {
    register(CardTableViewCell.self)
    showsVerticalScrollIndicator = false
    tableFooterView = UIView(frame: CGRect.zero)
    sectionFooterHeight = 0.0
    let height = UIScreen.main.bounds.height * 0.1
    contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
    separatorStyle = .none
  }
}
