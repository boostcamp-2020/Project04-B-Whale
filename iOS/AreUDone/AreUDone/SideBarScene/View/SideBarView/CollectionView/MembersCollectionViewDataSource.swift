//
//  MembersCollectionViewDataSource.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/05.
//

import UIKit

final class MembersCollectionViewDataSource: NSObject, UICollectionViewDataSource {

  // MARK: - Property

  private let viewModel: SideBarViewModelProtocol
  private var handler: (() -> Void)?


  // MARK: - Initializer

  init(viewModel: SideBarViewModelProtocol, handler: (() -> Void)? = nil) {
    self.viewModel = viewModel
    self.handler = handler
    
    super.init()
  }
  
  
  // MARK: - Method
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfMembers()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: MemberCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    
    if let member = viewModel.fetchMember(at: indexPath.item) {
      viewModel.fetchProfileImage(with: member.profileImageUrl) { data in
        DispatchQueue.main.async {
          cell.update(with: data, and: member)
        }
      }
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let footerView: MemberFooterView = collectionView.dequeReusableFooterView(forIndexPath: indexPath)
    
    footerView.update(with: "초대하기")
    footerView.handler = { [weak self] in
      self?.handler?()
    }
    return footerView
  }
}
