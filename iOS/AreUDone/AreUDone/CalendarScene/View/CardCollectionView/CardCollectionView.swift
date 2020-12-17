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
  
  func resetVisibleCellOffset(without cell: CardCollectionViewCell? = nil) {
    guard let cells = visibleCells as? [CardCollectionViewCell] else { return }

    cells.forEach({
      if $0 != cell {
        $0.resetOffset()
      }
    })
  }
}


// MARK:- Extension Configure Method

private extension CardCollectionView {
  
  func configure() {
    layer.cornerRadius = 10
    layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    backgroundColor = .clear
    showsVerticalScrollIndicator = false
    showsHorizontalScrollIndicator = false
    
    register(CardCollectionViewCell.self)
    configureFlowLayout()
  }
  
  func configureFlowLayout() {
    let layout = UICollectionViewFlowLayout()
    let height = UIScreen.main.bounds.height * 0.1
    let width = UIScreen.main.bounds.width * 0.8
    layout.itemSize = CGSize(width: width, height: height)
    layout.minimumInteritemSpacing = 10
    
    collectionViewLayout = layout
  }
}
