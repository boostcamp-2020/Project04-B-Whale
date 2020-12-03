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
}


// MARK:- Extension Configure Method

private extension BoardListCollectionView {
  
  func configure() {
    configureFlowLayout()
    registerCell()
  }
  
  func configureFlowLayout() {
    let flowLayout = UICollectionViewFlowLayout()
    let width = UIScreen.main.bounds.width * 0.9
    let height = UIScreen.main.bounds.height * 0.1
    flowLayout.itemSize = CGSize(width: width, height: height)
    flowLayout.headerReferenceSize = CGSize(width: bounds.width, height: bounds.height/15)

    collectionViewLayout = flowLayout
  }
  
  func registerCell() {
    registerHeaderView(BoardListCollectionViewHeader.self)
    register(BoardListCollectionViewCell.self)
  }
}
