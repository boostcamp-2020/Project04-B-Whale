//
//  BoardListCollectionView.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import UIKit

final class BoardListCollectionView: UICollectionView {
  
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
    registerHeaderView(BoardListCollectionViewHeader.self)
    register(BoardListCollectionViewCell.self)
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = CGSize(width: bounds.width, height: bounds.height/10)
    flowLayout.headerReferenceSize = CGSize(width: bounds.width, height: bounds.height/15)

    collectionViewLayout = flowLayout
  }
}