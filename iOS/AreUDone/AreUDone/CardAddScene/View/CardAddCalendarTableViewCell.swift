//
//  CardAddCalendarTableViewCell.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/10.
//

import UIKit

protocol CardAddCalendarTableViewCellDelegate: AnyObject {
  
  func textFieldDidChanged(with title: String)
}

final class CardAddCalendarTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Property
  
  weak var delegate: CardAddCalendarTableViewCellDelegate?
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.textAlignment = .left
    label.font = UIFont.nanumB(size: 18)
    label.text = "마감 날짜"
    
    return label
  }()
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configure()
  }
  
  
  // MARK: - Method
  
}


// MARK: - Extension Configure Method

private extension CardAddCalendarTableViewCell {
  
  func configure() {
    contentView.addSubview(titleLabel)
    
    configureTitleLabel()
  }
  
  func configureTitleLabel() {
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
}


