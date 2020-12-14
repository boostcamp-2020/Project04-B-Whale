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
  private weak var delegate: SideBarViewControllerProtocol?


  // MARK: - Initializer

  init(viewModel: SideBarViewModelProtocol, delegate: SideBarViewControllerProtocol) {
    self.viewModel = viewModel
    self.delegate = delegate
    
    super.init()
  }
  
  
  // MARK: - Method
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfMembers()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: MemberCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    
    if let member = viewModel.fetchMember(at: indexPath.item) {
      viewModel.fetchProfileImage(with: member.profileImageUrl, userName: member.name) { data in
        DispatchQueue.main.async {
          cell.update(with: data, and: member)
        }
      }
    }

    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let footerView: MemberFooterView = collectionView.dequeReusableFooterView(forIndexPath: indexPath)    
    footerView.delegate = delegate

    return footerView
  }
}
