//
//  ListCollectionView.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
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
  
  
  // MARK: - Method
  
  func configure() {
    
    register(ListCollectionViewCell.self)
  }
}

