//
//  SideBarHeaderView.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/02.
//

import UIKit

final class SideBarHeaderView: UICollectionReusableView, Reusable {
  
  // MARK: - Property
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    imageView.tintColor = .black
    
    return imageView
  }()
  private lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    return titleLabel
  }()
  private lazy var dividerView: UIView = {
    let dividerView = UIView()
    dividerView.translatesAutoresizingMaskIntoConstraints = false
    
    dividerView.backgroundColor = .lightGray
    
    return dividerView
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
  
  func update(withImageName imageName: String, andTitle title: String) {
    imageView.image = UIImage(systemName: imageName)
    titleLabel.text = title
  }
}


// MARK: - Extension Configure Method

private extension SideBarHeaderView {
  
  func configure() {
    backgroundColor = .white
    
    addSubview(imageView)
    addSubview(titleLabel)
    addSubview(dividerView)

    configureImageView()
    configureTitle()
    configureDividerView()
  }
  
  func configureImageView() {
    NSLayoutConstraint.activate([
      imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      imageView.widthAnchor.constraint(equalToConstant: 30),
      imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
    ])
  }
  
  func configureTitle() {
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
      titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
    ])
  }
  
  func configureDividerView() {
    NSLayoutConstraint.activate([
      dividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
      dividerView.widthAnchor.constraint(equalTo: widthAnchor),
      dividerView.heightAnchor.constraint(equalToConstant: 1)
    ])
  }
}
