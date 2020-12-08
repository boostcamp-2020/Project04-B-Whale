//
//  CommentCollectionViewCell.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/26.
//

import UIKit

final class CommentCollectionViewCell: UICollectionViewCell, Reusable {
  
  // MARK:- Property
  
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.masksToBounds = true
    
    return imageView
  }()
  
  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.nanumB(size: 15)
    
    return label
  }()
  
  private lazy var contentLabel: CardDetailContentLabel = {
    let label = CardDetailContentLabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  private lazy var createdAtLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.nanumR(size: 13)
    
    return label
  }()
  
  private lazy var editButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(systemName: "ellipsis")
    button.setImage(image, for: .normal)
    button.isHidden = true
    
    return button
  }()
  
  private lazy var width: NSLayoutConstraint = {
      let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
      width.isActive = true
      return width
  }()
  
  
  // MARK:- Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  
  // MARK:- Method
  
  override func systemLayoutSizeFitting(
    _ targetSize: CGSize,
    withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
    verticalFittingPriority: UILayoutPriority
  ) -> CGSize {
      width.constant = bounds.size.width
      return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 0))
  }
  
  func update(with comment: CardDetail.Comment) {
    nameLabel.text = comment.user.name
    contentLabel.text = comment.content
    createdAtLabel.text = comment.createdAt
  }
  
  func update(with image: UIImage?) {
    profileImageView.image = image
  }
}


// MARK:- Extension Configure Method

private extension CommentCollectionViewCell {
  func configure() {
    backgroundColor = .white
    contentView.addSubview(profileImageView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(contentLabel)
    contentView.addSubview(createdAtLabel)
    contentView.addSubview(editButton)
    
    configureContentView()
    configureProfileImageView()
    configureNameLabel()
    configureContentLabel()
    configureCreatedAtLabel()
    configureEditButton()
  }
  
  func configureContentView(){
    contentView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureProfileImageView() {
    NSLayoutConstraint.activate([
      profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      profileImageView.widthAnchor.constraint(equalToConstant: 40),
      profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor)
    ])
    
    profileImageView.layoutIfNeeded()
    profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
  }
  
  func configureNameLabel() {
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
      nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
      nameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
      nameLabel.heightAnchor.constraint(equalToConstant: 15)
    ])
  }
  
  func configureContentLabel() {
    NSLayoutConstraint.activate([
      contentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
      contentLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
      contentLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
      contentLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10)
    ])
  }
  
  func configureCreatedAtLabel() {
    NSLayoutConstraint.activate([
      createdAtLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 10),
      createdAtLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 5),
      createdAtLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
      createdAtLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
      createdAtLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
    ])
  }
  
  func configureEditButton() {
    NSLayoutConstraint.activate([
      editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
//      editButton.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
      editButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
      editButton.heightAnchor.constraint(equalToConstant: 15)
    ])
  }
}
