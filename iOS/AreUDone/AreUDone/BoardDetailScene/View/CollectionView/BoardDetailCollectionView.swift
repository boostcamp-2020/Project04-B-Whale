//
//  BoardDetailCollectionView.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
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
  
  
  // MARK: - Method
  
  func configure() {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = CGSize(width: 280, height: UIScreen.main.bounds.height * 0.8)
    flowLayout.scrollDirection = .horizontal
    collectionViewLayout = flowLayout
    
    register(BoardDetailCollectionViewCell.self)
  }
}
