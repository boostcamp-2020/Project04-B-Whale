//
//  BoardDetailCollectionViewDataSource.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/08.
//

import UIKit


final class BoardDetailCollectionViewDataSource: NSObject, UICollectionViewDataSource {
  
  // MARK: - Property
  
  private let viewModel: BoardDetailViewModelProtocol
  private var presentCardAddHandler: ((ListViewModelProtocol) -> Void)?
  private var presentCardDetailHandler: ((Int) -> Void)?

  
  
  // MARK: - Initializer
  
  init(
    viewModel: BoardDetailViewModelProtocol,
    presentCardAddHandler: ((ListViewModelProtocol) -> Void)? = nil,
    presentCardDetailHandler: ((Int) -> Void)? = nil
  ) {
    self.viewModel = viewModel
    self.presentCardAddHandler = presentCardAddHandler
    self.presentCardDetailHandler = presentCardDetailHandler
    
    super.init()
  }
  
  
  // MARK: - Method
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfLists()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: BoardDetailCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    
    viewModel.fetchListViewModel(at: indexPath.item) { viewModel in
      let dataSource = ListCollectionViewDataSource(viewModel: viewModel, presentCardAddHandler: presentCardAddHandler)
      cell.update(with: viewModel, dataSource: dataSource, presentCardDetailHandler: presentCardDetailHandler)
    }
  
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let footerView: BoardDetailFooterView = collectionView.dequeReusableFooterView(forIndexPath: indexPath)
    
    footerView.listAddHandler = { [weak self] title in
      self?.viewModel.createList(with: title)
    }
    return footerView
  }
}


