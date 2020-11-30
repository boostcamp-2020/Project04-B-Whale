//
//  CommentView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/30.
//

import UIKit

protocol CommentViewDelegate {
  func commentSaveButtonTapped(with comment: String)
}

final class CommentView: UIView {
  
  // MARK:- Property
  
  private lazy var profileImageView: UIImageView = {
    let view = UIImageView()
    let image = UIImage(systemName: "circle")
    view.image = image
    
    return view
  }()
  
  private lazy var commentTextField: CommentTextField = {
    let textField = CommentTextField()
    
    return textField
  }()
  
  private lazy var commentSaveButton: UIButton = {
    let button = UIButton()
    let image = UIImage(systemName: "paperplane.fill")
    button.setImage(image, for: .normal)
    button.isEnabled = false
    
    return button
  }()
  
  var delegate: CommentViewDelegate?
  
  // MARK:- Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
}


// MARK:- Extension Configure Method

private extension CommentView {
  
  func configure() {
    addSubview(profileImageView)
    addSubview(commentTextField)
    addSubview(commentSaveButton)
    
    configureView()
    configureProfileImageView()
    configureCommentTextField()
    configureCommentSaveButton()
    
    addingTarget()
  }
  
  func addingTarget() {
    commentTextField.addTarget(
      self,
      action: #selector(commentTextFieldEditting),
      for: .editingChanged
    )
    commentSaveButton.addTarget(
      self,
      action: #selector(commentSaveButtonTapped),
      for: .touchUpInside
    )
  }
  
  func configureView(){
    backgroundColor = .white
    layer.borderColor = UIColor.lightGray.cgColor
    layer.borderWidth = 0.3
  }
  
  func configureProfileImageView() {
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
      profileImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),
      profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor)
    ])
  }
  
  func configureCommentTextField() {
    commentTextField.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      commentTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
      commentTextField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
      commentTextField.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 5)
    ])
  }
  
  func configureCommentSaveButton() {
    commentSaveButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      commentSaveButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      commentSaveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
      commentSaveButton.leadingAnchor.constraint(equalTo: commentTextField.trailingAnchor, constant: 5),
      commentSaveButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),
      commentSaveButton.heightAnchor.constraint(equalTo: commentSaveButton.widthAnchor)
    ])
  }
}


// MARK:- Extension obj-c

private extension CommentView {
  
  @objc func commentTextFieldEditting() {
    if let comment = commentTextField.text {
      commentSaveButton.isEnabled = comment != "" ? true : false
    }
  }
  
  @objc func commentSaveButtonTapped() {
    if let comment = commentTextField.text,
       comment != "" {
      delegate?.commentSaveButtonTapped(with: comment)
      commentSaveButton.isEnabled = false
      commentTextField.text = ""
      commentTextField.resignFirstResponder()
    }
  }
}
