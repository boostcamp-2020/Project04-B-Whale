//
//  CommentView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/30.
//

import UIKit

protocol CommentViewDelegate {
  func commentTextFieldEditted()
  func commentSaveButtonTapped()
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


// MARK:- Extension Configure

private extension CommentView {
  
  func configure() {
    addSubview(profileImageView)
    addSubview(commentTextField)
    addSubview(commentSaveButton)
    
    configureView()
    configureProfileImageView()
    configureCommentTextField()
    configureCommentSaveButton()
  }
  
  func configureView(){
    backgroundColor = .white
    layer.borderColor = UIColor.lightGray.cgColor
    layer.borderWidth = 0.3
    
//    commentTextField.addTarget(self, action: #selector(commentTextFieldEditted), for: .editingDidBegin)
    commentSaveButton.addTarget(self, action: #selector(commentSaveButtonTapped), for: .touchUpInside)
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


// MARK:- Extension

private extension CommentView {
  
  @objc func commentTextFieldEditted() {
    delegate?.commentTextFieldEditted()
  }
  
  @objc func commentSaveButtonTapped() {
    delegate?.commentSaveButtonTapped()
    commentTextField.resignFirstResponder()
  }
}
