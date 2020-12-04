//
//  SideBarHeaderView.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/02.
//

import UIKit

final class SideBarHeaderView: UICollectionReusableView, Reusable {
  
  // MARK: - Property
  
  private lazy var imageTitleView: ImageTitleView = {
    let view = ImageTitleView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
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
    imageTitleView.update(withImageName: imageName, andTitle: title)
  }
}


// MARK: - Extension Configure Method

private extension SideBarHeaderView {
  
  func configure() {
    addSubview(imageTitleView)
    
   configureImageTitleView()
  }
  
  func configureImageTitleView() {
    NSLayoutConstraint.activate([
      imageTitleView.topAnchor.constraint(equalTo: topAnchor),
      imageTitleView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageTitleView.trailingAnchor.constraint(equalTo: trailingAnchor),
      imageTitleView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
    
  }
}


