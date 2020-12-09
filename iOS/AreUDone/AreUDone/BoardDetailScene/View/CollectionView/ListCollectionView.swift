//
//  ListCollectionView.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/29.
//

import UIKit

final class ListCollectionView: UICollectionView {
  
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

private extension ListCollectionView {
  
  func configure() {
    
    configureView()
    configureFlowLayout()
  }
  
  func configureView() {
    backgroundColor = .clear
    showsVerticalScrollIndicator = false
    
    register(ListCollectionViewCell.self)
    registerHeaderView(ListHeaderView.self)
    registerFooterView(ListFooterView.self)
  }
  
  func configureFlowLayout() {
    let flowLayout = UICollectionViewFlowLayout()
  
    flowLayout.headerReferenceSize = CGSize(width: bounds.width, height: 45)
    flowLayout.footerReferenceSize = CGSize(width: bounds.width, height: 45)
    flowLayout.itemSize = CGSize(width: bounds.width - 40, height: 40)
    
    flowLayout.sectionInset = UIEdgeInsets.sameInset(inset: 10)
   
    flowLayout.sectionHeadersPinToVisibleBounds = true
    flowLayout.sectionFootersPinToVisibleBounds = true
    
    collectionViewLayout = flowLayout
  }
  
  
}

