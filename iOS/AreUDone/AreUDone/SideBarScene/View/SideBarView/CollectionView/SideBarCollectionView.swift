//
//  SideBarCollectionView.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/04.
//

import UIKit

final class SideBarCollectionView: UICollectionView {
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    
    configure()
  }
}


// MARK: - Extension Configure Method

private extension SideBarCollectionView {
  
  func configure() {
    configureView()
    configureFlowLayout()
  }
  
  func configureView() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .white

    register(SideBarCollectionViewMembersCell.self)
    register(SideBarCollectionViewActivityCell.self)
    registerHeaderView(SideBarHeaderView.self)    
  }
  
  func configureFlowLayout() {
    let flowLayout = UICollectionViewFlowLayout()

    flowLayout.estimatedItemSize = CGSize(width: bounds.width, height: 30)
    flowLayout.headerReferenceSize = CGSize(width: bounds.width, height: 40)
    
    collectionViewLayout = flowLayout
  }
}
