//
//  DataSource.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/04.
//

import UIKit


final class SideBarCollectionViewDataSource: NSObject, UICollectionViewDataSource {
  
  // MARK: - Property
  
  private let viewModel: SideBarViewModelProtocol
  private weak var memberDataSource: UICollectionViewDataSource?
  
  
  // MARK: - Initializer
  
  init(viewModel: SideBarViewModelProtocol, memberDataSource: UICollectionViewDataSource) {
    self.viewModel = viewModel
    self.memberDataSource = memberDataSource
    
    super.init()
  }
  
  
  // MARK: - Method
  
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
      
      if let dataSource = memberDataSource {
        cell.update(with: dataSource)
      }
      
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
