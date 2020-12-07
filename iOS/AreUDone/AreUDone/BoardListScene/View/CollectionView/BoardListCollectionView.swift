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
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    configureFlowLayout()
  }
}


// MARK: - Extension Configure Method

private extension BoardListCollectionView {
  
  func configure() {
    configureView()
  }
  
  func configureView() {
    showsVerticalScrollIndicator = false
    contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    layer.cornerRadius = 10
    layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    
    register(BoardListCollectionViewCell.self)
  }
  
  func configureFlowLayout() {
    let flowLayout = UICollectionViewFlowLayout()
    let width = bounds.width * 0.9
    let height = bounds.height * 0.12
    flowLayout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
    flowLayout.itemSize = CGSize(width: width, height: height)

    collectionViewLayout = flowLayout
  }
}
