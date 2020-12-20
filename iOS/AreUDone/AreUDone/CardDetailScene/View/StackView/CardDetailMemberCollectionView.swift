//
//  CardDetailMemberCollectionView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/07.
//

import UIKit

final class CardDetailMemberCollectionView: UICollectionView {

  // MARK:- Property
  
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


// MARK:- Extension Configure Method

private extension CardDetailMemberCollectionView {
  
  func configure() {
    configureView()
    configureFlowLayout()
    registerCell()
  }
  
  func configureView() {
    backgroundColor = .white
    showsVerticalScrollIndicator = false
    showsHorizontalScrollIndicator = false
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
