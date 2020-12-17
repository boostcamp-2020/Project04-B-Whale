//
//  BoardAddTableView.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/07.
//

import UIKit

protocol TitleTableViewCellDelegate: AnyObject {
  
  func textFieldDidChanged(to title: String)
}

final class TitleTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Property
  
  weak var delegate: TitleTableViewCellDelegate?
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.textAlignment = .left
    label.font = UIFont.nanumB(size: 18)
    
    return label
  }()
  private lazy var textField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.font = UIFont.nanumR(size: 18)
    textField.becomeFirstResponder()
    
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
  
  func update(withTitle title: String, placeholder: String) {
    titleLabel.text = title
    textField.placeholder = placeholder
  }
  
  func boardTitle() -> String {
    return textField.text ?? ""
  }
}


// MARK: - Extension Configure Method

private extension TitleTableViewCell {
  
  func configure() {
    selectionStyle = .none
    
    contentView.addSubview(titleLabel)
    contentView.addSubview(textField)
    
    configureTitleLabel()
    configureTextField()
  }
  
  func configureTitleLabel() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
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
    delegate?.textFieldDidChanged(to: textField.text ?? "")
  }
}

