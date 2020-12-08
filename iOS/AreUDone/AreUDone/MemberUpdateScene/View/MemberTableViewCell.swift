//
//  MemberTableViewCell.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/07.
//

import UIKit

class MemberTableViewCell: UITableViewCell, Reusable {

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
    label.font = UIFont.nanumR(size: 18)
    
    return label
  }()
  
  
  // MARK:- Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configure()
  }
  
  func update(with name: String) {
    DispatchQueue.main.async { [weak self] in
      self?.nameLabel.text = name
    }
  }
  
  func update(with profileImage: UIImage?) {
    DispatchQueue.main.async { [weak self] in
      self?.profileImageView.image = profileImage
    }
  }
}


private extension MemberTableViewCell {
  
  func configure() {
    selectionStyle = .none
    
    addSubview(profileImageView)
    addSubview(nameLabel)
    
    configureProfileImageView()
    configureNameLabel()
  }
  
  func configureProfileImageView() {
    NSLayoutConstraint.activate([
      profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      profileImageView.widthAnchor.constraint(equalToConstant: 20),
      profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor)
    ])
    
    profileImageView.layoutIfNeeded()
    profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
  }
  
  func configureNameLabel() {
    NSLayoutConstraint.activate([
      nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15),
      nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
      nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      nameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
    ])
  }
}
