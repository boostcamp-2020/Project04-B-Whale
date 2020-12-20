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
  
  private lazy var dueDateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.textAlignment = .left
    label.font = UIFont.nanumR(size: 18)
    
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
  
  func update(with dateString: String) {
    dueDateLabel.text = dateString
  }
}


// MARK: - Extension Configure Method

private extension CardAddCalendarTableViewCell {
  
  func configure() {
    addSubview(titleLabel)
    addSubview(dueDateLabel)
    
    configureView()
    configureTitleLabel()
    configureDueDateLabel()
  }
  
  func configureView() {
    selectionStyle = .none
    accessoryType = .disclosureIndicator
  }
  
  func configureTitleLabel() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
    ])
  }
  
  func configureDueDateLabel() {
    NSLayoutConstraint.activate([
      dueDateLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
      dueDateLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
    ])
  }
}


