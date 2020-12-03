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
  
  private lazy var collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    
    flowLayout.itemSize = CGSize(width: 70, height: 70)
    flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    flowLayout.minimumInteritemSpacing = 10
    
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    collectionView.backgroundColor = #colorLiteral(red: 0.9525901473, green: 1, blue: 0.9893702928, alpha: 1)
    
    collectionView.dataSource = self
    collectionView.register(MemberCell.self)
    
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
  
  func update(with viewModel: SideBarViewModelProtocol) {
    
    self.viewModel = viewModel
    self.collectionView.reloadData()
  }
  
  override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    super.preferredLayoutAttributesFitting(layoutAttributes)
    
    // TODO: 주석 삭제 예정
    // 현재 cell 을 layoutifneeded 하면 하위 view 들도 다시 그려지면서(layoutsubviews) 하위뷰인 collectionview 의 contentsize가 잡히게 됨 -> 그 contentsize 의 height 를 가지고 layoutattribute 를 설정해주면 끝!!
    
    // 이 cell 을 가진 상위 모듈(collectionview 를 가지는 모듈)에서 collectionview.reloaddata를 해주면 호출됨.
    
    // reloaddata -> numberOfItemsInSection -> 하위 컬렉션뷰의 contentsize 잡힘 -> preferredlayoutattributesfitting 실행 
    layoutIfNeeded()

    layoutAttributes.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: collectionView.contentSize.height)
   
    return layoutAttributes
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
      collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor)
    ])
  }
}


// MARK: - Extension

extension SideBarCollectionViewMembersCell: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfMembers()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: MemberCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    
    if let member = viewModel.fetchMember(at: indexPath.item) {
      cell.update(with: member)
    }
    
    return cell
  }
}


