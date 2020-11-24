//
//  CardCollectionView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/24.
//

import UIKit

final class CardCollectionView: UICollectionView {

  // MARK:- Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    
    configure()
  }
  
  
  // MARK:- Method
  
  private func configure() {
    let height = UIScreen.main.bounds.height * 0.15
    contentInset = UIEdgeInsets(top: height, left: 0, bottom: height / 2, right: 0)
    
    register(CardCollectionViewCell.self)
    configureFlowLayout()
  }
  
  private func configureFlowLayout() {
    let layout = UICollectionViewFlowLayout()
    let height = UIScreen.main.bounds.height * 0.1
    let width = UIScreen.main.bounds.width * 0.8
    layout.itemSize = CGSize(width: width, height: height)
    layout.minimumInteritemSpacing = 10
    
    collectionViewLayout = layout
  }
}
