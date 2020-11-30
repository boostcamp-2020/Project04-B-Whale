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
    let image = UIImage(systemName: "circle")
    imageView.image = image
    
    return imageView
  }()
  
  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    
    return label
  }()
  
  private lazy var contentLabel: UILabel = {
    let label = UILabel()
    
    return label
  }()
  
  private lazy var createdAtLabel: UILabel = {
    let label = UILabel()
    
    return label
  }()
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  func update(with comment: CardDetail.Comment) {
    nameLabel.text = comment.user.name
    contentLabel.text = comment.content
    createdAtLabel.text = comment.createdAt
  }
}


// MARK:- Extension Configure Method

private extension CommentCollectionViewCell {
  func configure() {
    backgroundColor = .white
    addSubview(profileImageView)
    addSubview(nameLabel)
    addSubview(contentLabel)
    addSubview(createdAtLabel)
    
    configureProfileImageView()
    configureNameLabel()
    configureContentLabel()
    configureCreatedAtLabel()
  }
  
  func configureProfileImageView() {
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      profileImageView.widthAnchor.constraint(equalToConstant: 20),
      profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor)
    ])
  }
  
  func configureNameLabel() {
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
      nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
      nameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
    ])
  }
  
  func configureContentLabel() {
    contentLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      contentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
      contentLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
      contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
    ])
  }
  
  func configureCreatedAtLabel() {
    createdAtLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      createdAtLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 10),
      createdAtLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 10),
      createdAtLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
      createdAtLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
    ])
  }
}
