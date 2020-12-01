//
//  SideBarView.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/01.
//

import UIKit

final class SideBarView: UIView {
  
  // MARK: - Property
  
  @IBOutlet weak var collectionView: UICollectionView! {
    didSet {
      collectionView.dataSource = self
      collectionView.delegate = self
      collectionView.register(SideBarCollectionViewActivityCell.self)
      // TODO: 헤더뷰 만들어주기
      
      let flowLayout = UICollectionViewFlowLayout()
      flowLayout.estimatedItemSize = CGSize(width: bounds.width, height: 30)
      
      collectionView.collectionViewLayout = flowLayout
    }
  }
  
  
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
  
  
  
}

// MARK: - Extension Configure Method

private extension SideBarView {
  
  func configure() {
    nibSetup()
  }
}


// MARK: - Extension UICollectionView DataSource

extension SideBarView: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 35
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: SideBarCollectionViewActivityCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    
    cell.update(with: "더미 데이터")
    return cell
  }
}


// MARK: - Extension UICollectionView Delegate

extension SideBarView: UICollectionViewDelegate {

}


// MARK:- Extension NibLoad

private extension SideBarView {

  func nibSetup() {
    guard let view = loadViewFromNib() else { return }
    view.frame = bounds
    view.backgroundColor = .clear
    addSubview(view)
  }
  
  func loadViewFromNib() -> UIView? {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: String(describing: SideBarView.self), bundle: bundle)
    return nib.instantiate(withOwner: self, options: nil).first! as? UIView
  }
}
