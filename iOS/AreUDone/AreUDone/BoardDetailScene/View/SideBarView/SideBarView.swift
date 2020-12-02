//
//  SideBarView.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/01.
//

import UIKit

final class SideBarView: UIView {
  
  enum Section {
    case member
    case activity
  }
  
  
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
  
  private let viewModel: SideBarViewModelProtocol
  
  
  // MARK: - Initializer
  
  init(frame: CGRect, viewModel: SideBarViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(frame: frame)
    
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("The class should initialized with code")
  }
  
  
  // MARK: - Method
  
}

// MARK: - Extension Configure Method

private extension SideBarView {
  
  func configure() {
    nibSetup()
    bindUI()
    
    viewModel.updateActivitiesInCollectionView()
  }
}


// MARK: - Extension UICollectionView DataSource

extension SideBarView: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1 // TODO: 팩토리로 변경 예정
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfActivities()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: SideBarCollectionViewActivityCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    
    let activity = viewModel.fetchActivity(at: indexPath.row)
    cell.update(with: activity)
    
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


// MARK: - Extension UIBind

private extension SideBarView {
  
  func bindUI() {
    viewModel.bindingUpdateMembersInCollectionView { [weak self] in
      DispatchQueue.main.async {
        self?.collectionView.reloadSections(IndexSet(integer: 0))
      }
    }
    
    viewModel.bindingUpdateActivitiesInCollectionView { [weak self] in
      DispatchQueue.main.async {
        self?.collectionView.reloadSections(IndexSet(integer: 0)) // TODO: 1로 수정
      }
    }
  }
}
