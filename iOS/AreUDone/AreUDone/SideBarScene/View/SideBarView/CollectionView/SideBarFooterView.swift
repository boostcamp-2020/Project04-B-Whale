//
//  SideBarBottomView.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/03.
//

import UIKit

final class SideBarFooterView: UICollectionReusableView, Reusable {
  
  // MARK: - Property
  
  private lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    return titleLabel
  }()
  
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .red
    configure()
  }
}


// MARK: - Extension Configure Method

private extension SideBarFooterView {
  
  func configure() {
    addSubview(titleLabel)
    
    configureTitleLabel()
  }
  
  func configureTitleLabel() {
    NSLayoutConstraint.activate([
      
    ])
  }
}
