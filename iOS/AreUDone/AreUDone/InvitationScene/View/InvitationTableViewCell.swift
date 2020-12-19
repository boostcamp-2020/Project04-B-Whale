//
//  InvitationCollectionViewCell.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/05.
//

import UIKit

final class InvitationTableViewCell: UITableViewCell, Reusable {

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
 
  func update(with data: Data, and user: (User, Bool)) {
    profileImageView.image = UIImage(data: data)
    textLabel?.text = user.0.name
    
    let imageName = user.1 ? "checkmark.circle" : "plus.circle"
    let color = user.1 ? UIColor.gray : UIColor.systemBlue
    
    accessoryView = UIImageView(image: UIImage(systemName: imageName))
    accessoryView?.tintColor = color
  }
}


// MARK: - Extension Configure Method

private extension InvitationTableViewCell {
  
  func configure() {
    selectionStyle = .none
    addSubview(profileImageView)
    
    configureView()
    configureProfileImageView()
  }
  
  func configureView() {
    textLabel?.textAlignment = .center
    textLabel?.font = UIFont.nanumR(size: 16)
    
  }
  
  func configureProfileImageView() {
    NSLayoutConstraint.activate([
      profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
      profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor),
      profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
    ])
    
    profileImageView.layoutIfNeeded()
    profileImageView.layer.cornerRadius = profileImageView.bounds.width/2
  }
}
