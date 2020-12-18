//
//  ImageTitleView.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/04.
//

import UIKit

final class ImageTitleView: UIView {
  
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
    titleLabel.font = UIFont.nanumB(size: 20)

    return titleLabel
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

private extension ImageTitleView {
  
  func configure() {
    backgroundColor = .white
    
    addSubview(imageView)
    addSubview(titleLabel)
    
    configureImageView()
    configureTitle()
    configureTopDividerView()
    configureBottomDividerView()
  }
  
  func configureImageView() {
    NSLayoutConstraint.activate([
      imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      imageView.widthAnchor.constraint(equalToConstant: 20)
    ])
  }
  
  func configureTitle() {
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
      titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
    ])
  }
  
  func configureTopDividerView() {
    let view = UIView.dividerView()
    addSubview(view)
    
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: topAnchor),
      view.widthAnchor.constraint(equalTo: widthAnchor),
      view.heightAnchor.constraint(equalToConstant: 1)
    ])
  }
  
  func configureBottomDividerView() {
    let view = UIView.dividerView()
    addSubview(view)
    
    NSLayoutConstraint.activate([
      view.bottomAnchor.constraint(equalTo: bottomAnchor),
      view.widthAnchor.constraint(equalTo: widthAnchor),
      view.heightAnchor.constraint(equalToConstant: 1)
    ])
  }
}
