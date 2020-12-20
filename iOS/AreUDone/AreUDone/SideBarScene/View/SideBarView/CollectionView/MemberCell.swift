//
//  MemberCell.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/02.
//

import UIKit

final class MemberCell: UICollectionViewCell, Reusable {
  
  // MARK: - Property
  
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    imageView.layer.borderWidth = 0.5
    imageView.layer.borderColor = UIColor.darkGray.cgColor
    imageView.layer.masksToBounds = true

    imageView.image = UIImage(systemName: "person")
    
    return imageView
  }()
  
  private lazy var profileId: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.font = UIFont.nanumB(size: 13)
    label.textColor = .black
    
    return label
  }()
  
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    profileImageView.image = nil
    profileId.text = nil
  }
  
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
  
  func update(with imageData: Data, and member: User) {
    profileImageView.image = UIImage(data: imageData)
    profileId.text = member.name
  }
}


// MARK: - Extension Configure Method

private extension MemberCell {
  
  func configure() {
    addSubview(profileImageView)
    addSubview(profileId)
    
    configureProfileImageView()
    configureProfileId()
  }
  
  func configureProfileImageView() {
    NSLayoutConstraint.activate([
      profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor),
      profileImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6)
    ])
    
    profileImageView.layoutIfNeeded()
    profileImageView.layer.cornerRadius = profileImageView.frame.width/2
  }
  
  func configureProfileId() {
    NSLayoutConstraint.activate([
      profileId.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
      profileId.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5),
      profileId.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
    ])
  }
}
