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
  private var presentCardAddHandler: ((Int) -> Void)?
  
  
  // MARK: - Initializer
  
  init(viewModel: BoardDetailViewModelProtocol, presentCardAddHandler: ((Int) -> Void)? = nil) {
    self.viewModel = viewModel
    self.presentCardAddHandler = presentCardAddHandler
    
    super.init()
  }
  
  
  // MARK: - Method
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfLists()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: BoardDetailCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    
    // TODO: 카드 id 가 있는 핸들러(카드상세화면), 리스트 id 가 있는 핸들러(카드 추가 화면)
    viewModel.fetchListViewModel(at: indexPath.item) { viewModel in
      let dataSource = ListCollectionViewDataSource(viewModel: viewModel, presentCardAddHandler: presentCardAddHandler)
      cell.update(with: viewModel, dataSource: dataSource)
    }
  
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let footerView: BoardDetailFooterView = collectionView.dequeReusableFooterView(forIndexPath: indexPath)
    
    footerView.addHandler = { [weak self] title in
      self?.viewModel.createList(with: title)
    }
    return footerView
  }
}


