//
//  CommentView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/30.
//

import UIKit

protocol CommentViewDelegate: AnyObject {
  
  func commentSaveButtonTapped(with comment: String)
}

final class CommentView: UIView {
  
  // MARK:- Property
  
  private lazy var profileImageView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.masksToBounds = true
    
    return view
  }()
  
  private lazy var commentTextField: CommentTextField = {
    let textField = CommentTextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    return textField
  }()
  
  private lazy var commentSaveButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(systemName: "paperplane.fill")
    button.setImage(image, for: .normal)
    button.isEnabled = false
    
    return button
  }()
  
  weak var delegate: CommentViewDelegate?
  
  // MARK:- Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  func update(with profileImage: UIImage?) {
    profileImageView.image = profileImage
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
    NSLayoutConstraint.activate([
      profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
      profileImageView.widthAnchor.constraint(equalToConstant: 50),
      profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor)
    ])
    
    profileImageView.layoutIfNeeded()
    profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
  }
  
  func configureCommentTextField() {
    NSLayoutConstraint.activate([
      commentTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
      commentTextField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
      commentTextField.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 5)
    ])
  }
  
  func configureCommentSaveButton() {
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
    guard let comment = commentTextField.text else { return }
    
    commentSaveButton.isEnabled = !comment.isEmpty ? true : false
  }
  
  @objc func commentSaveButtonTapped() {
    guard
      let comment = commentTextField.text,
      !comment.isEmpty
    else { return }
    
    delegate?.commentSaveButtonTapped(with: comment)
    commentSaveButton.isEnabled = false
    commentTextField.text = .none
    commentTextField.resignFirstResponder()
    
  }
}
