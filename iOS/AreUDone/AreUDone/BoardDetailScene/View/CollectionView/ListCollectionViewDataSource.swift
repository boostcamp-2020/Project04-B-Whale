//
//  ListCollectionViewDataSource.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/08.
//

import UIKit


final class ListCollectionViewDataSource: NSObject, UICollectionViewDataSource {
  
  // MARK: - Property
  
  private let viewModel: ListViewModelProtocol
  private var presentCardAddHandler: ((Int) -> Void)?
  
  
  // MARK: - Initializer
  
  init(viewModel: ListViewModelProtocol, presentCardAddHandler: ((Int) -> Void)?) {
    self.viewModel = viewModel
    self.presentCardAddHandler = presentCardAddHandler

    super.init()
  }
  
  
  // MARK: - Method
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfCards()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: ListCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    
    cell.update(with: viewModel.fetchCard(at: indexPath.row))
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      let headerView: ListHeaderView = collectionView.dequeReusableHeaderView(forIndexPath: indexPath)
      
      headerView.update(with: viewModel)
      
      return headerView
      
    case UICollectionView.elementKindSectionFooter:
      // TODO: 여기서 카드 추가화면 띄우는 로직 필요
      // viewmodel.createCard(리스트id) 핸들러? footerview에게 넘겨주기
      let footerView: ListFooterView = collectionView.dequeReusableFooterView(forIndexPath: indexPath)
      footerView.delegate = self
      
      return footerView
      
    default:
      return UICollectionReusableView()
    }
  }
}


// MARK: - Extension

extension ListCollectionViewDataSource: ListFooterViewDelegate {
  
  func baseViewTapped() {
    let listId = viewModel.fetchListId()
    presentCardAddHandler?(listId)
  }
}
