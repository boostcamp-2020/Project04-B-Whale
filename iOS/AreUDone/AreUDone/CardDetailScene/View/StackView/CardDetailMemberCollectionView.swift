//
//  CardDetailMemberCollectionView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/07.
//

import UIKit

final class CardDetailMemberCollectionView: UICollectionView {

  override var contentSize:CGSize {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }
  
  override var intrinsicContentSize: CGSize {
    layoutIfNeeded()
    return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
  }
  
  // MARK:- Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    
    configure()
  }

}


private extension CardDetailMemberCollectionView {
  
  func configure() {
    backgroundColor = .white
    showsVerticalScrollIndicator = false
    showsHorizontalScrollIndicator = false
    
    configureFlowLayout()
    registerCell()
  }
  
  func configureFlowLayout() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 40, height: 40)
    
    collectionViewLayout = layout
  }
  
  func registerCell() {
    register(CardDetailMemberCollectionViewCell.self)
  }
}
