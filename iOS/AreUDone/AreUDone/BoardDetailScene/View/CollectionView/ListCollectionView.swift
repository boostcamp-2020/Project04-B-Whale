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

extension ListCollectionView {
  
  func configure() {
    register(ListCollectionViewCell.self)
    registerHeaderView(ListHeaderView.self)
    registerFooterView(ListFooterView.self)
    
    backgroundColor = .clear
    showsVerticalScrollIndicator = false
  }
}

