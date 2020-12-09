//
//  AddOrCancelView.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/30.
//

import UIKit

protocol AddOrCancelViewDelegate: AnyObject {
  
  func addButtonTapped(listTitle: String)
  func cancelButtonTapped()
}

final class AddOrCancelView: UIView {
  
  // MARK: - Property
  
  weak var delegate: AddOrCancelViewDelegate?
  
  private lazy var textFieldView: TextField = {
    let textField = TextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    textField.backgroundColor = .white
    textField.layer.cornerRadius = 5
    textField.layer.borderWidth = 0.2
    
    return textField
  }()
  private lazy var cancelButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.setTitle("취소", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    button.setTitleColor(.darkGray, for: .normal)
    
    button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    
    return button
  }()
  private lazy var addButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    button.setTitle("만들기", for: .normal)
    button.setTitleColor(.darkGray, for: .normal)
    
    button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    
    return button
  }()
  
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  // MARK: - Method
  
  @objc private func addButtonTapped() {
    delegate?.addButtonTapped(listTitle: textFieldView.text ?? "")
  }
  
  @objc private func cancelButtonTapped() {
    delegate?.cancelButtonTapped()
  }
}


// MARK: - Extension Configure Method

private extension AddOrCancelView {
  
  func configure() {
    addSubview(textFieldView)
    addSubview(cancelButton)
    addSubview(addButton)
    
    configureView()
    configureTextFieldView()
    configureCancelButton()
    configureAddButton()
  }
  
  func configureView() {
    backgroundColor = #colorLiteral(red: 0.944453299, green: 0.9647708535, blue: 0.9688996673, alpha: 1)
    layer.cornerRadius = 10
  }
  
  func configureTextFieldView() {
    NSLayoutConstraint.activate([
      textFieldView.centerXAnchor.constraint(equalTo: centerXAnchor),
      textFieldView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      textFieldView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
      textFieldView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
      
      textFieldView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45)
    ])
  }
  
  func configureCancelButton() {
    NSLayoutConstraint.activate([
      cancelButton.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 10),
      cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
    ])
  }
  
  func configureAddButton() {
    NSLayoutConstraint.activate([
      addButton.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -10),
      addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
    ])
  }
}



final class TextField: UITextField {
  
  // MARK: - Property
  
  let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
  
  override public func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override public func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
}
