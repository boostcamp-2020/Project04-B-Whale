//
//  CardDetailMemberCollectionViewCell.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/07.
//

import UIKit

final class CardDetailMemberCollectionViewCell: UICollectionViewCell, Reusable {
  
  // MARK:- Property
  
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.masksToBounds = true
    
    return imageView
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
  
  func update(with image: UIImage?) {
    DispatchQueue.main.async { [weak self] in
      self?.profileImageView.image = image
    }
  }
}


private extension CardDetailMemberCollectionViewCell {
  
  func configure(){
    addSubview(profileImageView)
    
    configureContentView()
    configureProfileImageView()
  }
  
  func configureContentView() {
    contentView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureProfileImageView() {
    NSLayoutConstraint.activate([
      profileImageView.topAnchor.constraint(equalTo: topAnchor),
      profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
      profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      profileImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
    
    profileImageView.layoutIfNeeded()
    profileImageView.layer.cornerRadius =  profileImageView.frame.width / 2
  }
}
