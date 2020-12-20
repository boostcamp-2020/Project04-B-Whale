//
//  SideBarCllectionViewMemberCell.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/02.
//

import UIKit

final class SideBarCollectionViewMembersCell: UICollectionViewCell, Reusable {
  
  // MARK: - Property
  
  private var viewModel: SideBarViewModelProtocol!
  
  private lazy var collectionView: MemberCollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    let collectionView = MemberCollectionView(frame: bounds, collectionViewLayout: flowLayout)
    
    return collectionView
  }()
  
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  
  // MARK: - Method
  
  override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    super.preferredLayoutAttributesFitting(layoutAttributes)
    layoutIfNeeded()

    layoutAttributes.frame = CGRect(
      x: frame.origin.x,
      y: frame.origin.y,
      width: frame.width,
      height: collectionView.contentSize.height
    )
   
    return layoutAttributes
  }
  
  func update(with dataSource: UICollectionViewDataSource) {
    collectionView.dataSource = dataSource
    
    self.collectionView.reloadData()
  }
}


// MARK: - Extension Configure Method

private extension SideBarCollectionViewMembersCell {
  
  func configure() {
    addSubview(collectionView)

    configureCollectionView()
  }
  
  func configureCollectionView() {
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
}
