//
//  SettingTableViewCell.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/15.
//

import UIKit

final class SettingTableViewCell: UITableViewCell, Reusable {
  
  // MARK:- Property
  
  private lazy var titleLable: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.nanumB(size: 20)
    
    return label
  }()
  
  
  // MARK:- Initializer
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configure()
  }
  
  func update(with title: String) {
    titleLable.text = title
  }
}


private extension SettingTableViewCell {
  
  func configure(){
    selectionStyle = .none
    contentView.addSubview(titleLable)
    
    configureContentView()
    configureTitleLabel()
  }
  
  func configureContentView() {
    contentView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureTitleLabel() {
    NSLayoutConstraint.activate([
      titleLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      titleLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
      titleLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
      titleLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }
}
