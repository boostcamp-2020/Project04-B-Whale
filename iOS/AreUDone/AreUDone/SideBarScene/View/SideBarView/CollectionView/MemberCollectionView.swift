//
//  MemberCollectionView.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/04.
//

import UIKit

final class MemberCollectionView: UICollectionView {
  
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


// MARK: - Extension Configure Method

private extension MemberCollectionView {
  
  func configure() {
    configureView()
    configureFlowLayout()
  }
  
  func configureView() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .white
    
    register(MemberCell.self)
    registerFooterView(MemberFooterView.self)
  }
  
  func configureFlowLayout() {
    let flowLayout = UICollectionViewFlowLayout()
    
    flowLayout.itemSize = CGSize(width: 70, height: 70)
    flowLayout.footerReferenceSize = CGSize(width: bounds.width, height: 50)
    
    flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    flowLayout.minimumInteritemSpacing = 10
    
    collectionViewLayout = flowLayout
  }
}

