//
//  BoardAddTableView.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/07.
//

import UIKit

protocol BoardTitleTableViewCellDelegate: AnyObject {
  
  func textFieldDidChanged(with title: String)
}

final class BoardTitleTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Property
  
  weak var delegate: BoardTitleTableViewCellDelegate?
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.textAlignment = .left
    label.font = UIFont.nanumB(size: 18)
    label.text = "보드 제목"
    
    return label
  }()
  private lazy var textField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    textField.font = UIFont.nanumR(size: 18)
    textField.placeholder = "보드 제목을 입력해주세요"
    
    return textField
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
  
  func boardTitle() -> String {
    return textField.text ?? ""
  }
}


// MARK: - Extension Configure Method

private extension BoardTitleTableViewCell {
  
  func configure() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(textField)
    
    configureTitleLabel()
    configureTextField()
  }
  
  func configureTitleLabel() {
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  func configureTextField() {
    textField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
    
    NSLayoutConstraint.activate([
      textField.topAnchor.constraint(equalTo: contentView.topAnchor),
      textField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 5),
      textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
  
  @objc func textFieldDidChanged() {
    delegate?.textFieldDidChanged(with: textField.text ?? "")
  }
}

