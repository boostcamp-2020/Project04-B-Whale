//
//  CommentCollectionView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/26.
//

import UIKit

class CommentCollectionView: UICollectionView {

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    
    configure()
  }

  private func configure() {
    configureFlowLayout()
    registerCell()
  }
  
  private func configureFlowLayout() {
    let layout = UICollectionViewFlowLayout()
    let height = UIScreen.main.bounds.height * 0.1
    let width = UIScreen.main.bounds.width * 0.8
    layout.itemSize = CGSize(width: width, height: height)
    layout.minimumInteritemSpacing = 10
    
    collectionViewLayout = layout
  }
  
  private func registerCell() {
    register(CommentCollectionViewCell.self)
  }
}
