//
//  RefreshView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/21.
//

import UIKit

final class RefreshView: UIView {
  
  // MARK:- Property
  
  private lazy var refreshImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(systemName: "arrow.triangle.2.circlepath")
    imageView.image = image
    imageView.tintColor = .white
    imageView.isUserInteractionEnabled = true
    
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
  
  func rotateRefreshImage(forCount count: Float) {
    refreshImageView.rotate(forCount: count)
  }
}


// MARK:- Extension Configure Method

private extension RefreshView {
  
  func configure() {
    addSubview(refreshImageView)
    
    configureView()
    configureRefreshImageView()
  }
  
  func configureView() {
    isUserInteractionEnabled = true
    layer.borderColor = UIColor.black.cgColor
    layer.cornerRadius = 5
    backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
  }
  
  func configureRefreshImageView() {
    NSLayoutConstraint.activate([
      refreshImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      refreshImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
    ])
  }
}
