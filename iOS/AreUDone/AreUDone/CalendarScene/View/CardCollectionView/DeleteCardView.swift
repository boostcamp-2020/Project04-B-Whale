//
//  DeleteCardView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/24.
//

import UIKit

final class DeleteCardView: UIView {

  // MARK:- Property
  
  private lazy var deleteImageView: UIImageView = {
    let imageView = UIImageView()
    let image = UIImage(systemName: "trash")
    imageView.tintColor = .white
    imageView.image = image
    
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
}


// MARK:- Extension Configure Method

private extension DeleteCardView {
  
  private func configure() {
    configureView()
    configureDeleteImageView()
  }
  
  private func configureView() {
    backgroundColor = .systemRed
    layer.maskedCorners = [
      .layerMaxXMinYCorner,
      .layerMaxXMaxYCorner
    ]
    layer.cornerCurve = .continuous
    layer.cornerRadius = 10
  }

  private func configureDeleteImageView() {
    addSubview(deleteImageView)
    deleteImageView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      deleteImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      deleteImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      deleteImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
      deleteImageView.widthAnchor.constraint(equalTo: deleteImageView.heightAnchor)
    ])
  }
}
