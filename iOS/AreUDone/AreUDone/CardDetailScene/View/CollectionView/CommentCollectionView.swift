//
//  CommentCollectionView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/26.
//

import UIKit

final class CommentCollectionView: UICollectionView {

  override var contentSize:CGSize {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }
  
  override var intrinsicContentSize: CGSize {
    layoutIfNeeded()
    return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
  }
  
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    
    configure()
  }

  private func configure() {
    backgroundColor = .white
    isScrollEnabled = false
    configureFlowLayout()
    registerCell()
  }
  
  private func configureFlowLayout() {
    let layout = UICollectionViewFlowLayout()
    let height = UIScreen.main.bounds.height * 0.1
    let width = UIScreen.main.bounds.width * 0.9
    layout.estimatedItemSize = CGSize(width: width, height: height)
    layout.minimumInteritemSpacing = 10
    collectionViewLayout = layout
  }
  
  private func registerCell() {
    register(CommentCollectionViewCell.self)
  }
}
