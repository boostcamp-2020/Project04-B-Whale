//
//  SettingTableViewCell.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/15.
//

import UIKit

final class SettingTableViewCell: UITableViewCell, Reusable {
  
  // MARK:- Property
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.font = UIFont.nanumB(size: 20)
    
    return label
  }()
  
  
  // MARK:- Initializer
  
  required init?(coder: NSCoder) {
    fatalError("This class Should be initialized with code")
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configure()
  }
  
  
  // MARK: - Method
  
  func update(with title: String) {
    titleLabel.text = title
  }
}


// MARK: - Extension Configure Method

private extension SettingTableViewCell {
  
  func configure(){
    selectionStyle = .none
    contentView.addSubview(titleLabel)
    
    configureContentView()
    configureTitleLabel()
  }
  
  func configureContentView() {
    contentView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureTitleLabel() {
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
      titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }
}
