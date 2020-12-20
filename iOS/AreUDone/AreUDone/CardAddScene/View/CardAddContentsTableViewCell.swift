//
//  CardAddContentsTableViewCell.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/10.
//

import UIKit

final class CardAddContentsTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Property
    
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.textAlignment = .left
    label.font = UIFont.nanumB(size: 18)
    label.text = "내용 입력"
    
    return label
  }()
  private lazy var contents: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.textAlignment = .left
    label.font = UIFont.nanumR(size: 18)
    label.numberOfLines = 0
   
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
  
  func update(withContent content: String) {
    contents.text = content
  }
}


// MARK: - Extension Configure Method

private extension CardAddContentsTableViewCell {
  
  func configure() {
    selectionStyle = .none
    
    addSubview(titleLabel)
    addSubview(contents)
    
    configureView()
    configureTitleLabel()
    configureContents()
  }
  
  func configureView() {
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
  
  func configureContents() {
    NSLayoutConstraint.activate([
      contents.topAnchor.constraint(equalTo: topAnchor, constant:  10),
      contents.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
      contents.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
      contents.bottomAnchor.constraint(equalTo: bottomAnchor, constant:  -10)
    ])
  }
}


