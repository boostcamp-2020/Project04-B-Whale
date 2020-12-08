//
//  BoardDetailCollectionView.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/08.
//

import UIKit

final class BoardDetailCollectionView: UICollectionView {
  
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

private extension BoardDetailCollectionView {
  
  func configure() {
    configureView()
  }
  
  func configureView() {
    backgroundColor = .clear
    showsHorizontalScrollIndicator = false
    decelerationRate = UIScrollView.DecelerationRate.fast
    
    register(BoardDetailCollectionViewCell.self)
    registerFooterView(BoardDetailFooterView.self)
  }
}


