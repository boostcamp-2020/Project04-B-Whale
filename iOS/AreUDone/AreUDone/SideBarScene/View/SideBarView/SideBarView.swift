//
//  SideBarView.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/01.
//

import UIKit

final class SideBarView: UIView {
  
  // MARK: - Enum
  
  enum Section {
    case member
    case activity
  }
  
  
  // MARK: - Property
  
  @IBOutlet weak var collectionView: UICollectionView! {
    didSet {
      collectionView.dataSource = self
      collectionView.delegate = self
      collectionView.register(SideBarCollectionViewMembersCell.self)
      collectionView.register(SideBarCollectionViewActivityCell.self)
      collectionView.registerHeaderView(SideBarHeaderView.self)
      
      let flowLayout = UICollectionViewFlowLayout()
      flowLayout.estimatedItemSize = CGSize(width: bounds.width, height: 30)
      flowLayout.headerReferenceSize = CGSize(width: bounds.width, height: 40)
      
      flowLayout.sectionHeadersPinToVisibleBounds = true
      
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
}



// MARK: - Extension Configure Method

private extension SideBarView {
  
  func configure() {
    nibSetup()
    bindUI()
 
    viewModel.updateMembersInCollectionView()
    viewModel.updateActivitiesInCollectionView()
  }
}


// MARK: - Extension UICollectionView DataSource

extension SideBarView: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
      
    case 1:
      return viewModel.numberOfActivities()
      
    default:
      return 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    switch indexPath.section {
    case 0:
      let cell: SideBarCollectionViewMembersCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      
      cell.update(with: viewModel)
      
      return cell
      
    case 1:
      let cell: SideBarCollectionViewActivityCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      
      let activity = viewModel.fetchActivity(at: indexPath.row)
      cell.update(with: activity)
      
      return cell
      
    default:
      return UICollectionViewCell()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let headerView: SideBarHeaderView = collectionView.dequeReusableHeaderView(forIndexPath: indexPath)
    
    let (imageName, title) = viewModel.fetchSectionHeader(at: indexPath.section)
    headerView.update(withImageName: imageName, andTitle: title)
    
    return headerView
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
        self?.collectionView.reloadData()
//        self?.collectionView.reloadSections(IndexSet(integer: 0))
      }
    }
    
    // TODO: reloadSection 시 경고 뜨는 이유 알아보기
    viewModel.bindingUpdateActivitiesInCollectionView { [weak self] in
      DispatchQueue.main.async {
        self?.collectionView.reloadData()
//        self?.collectionView.reloadSections(IndexSet(integer: 1))
      }
    }
  }
}
