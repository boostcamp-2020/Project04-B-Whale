//
//  BoardDetailCollectionViewCell.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import UIKit
import MobileCoreServices

final class BoardDetailCollectionViewCell: UICollectionViewCell, Reusable {
  
  // MARK: - Property
  
  lazy var collectionView: ListCollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
  
    flowLayout.headerReferenceSize = CGSize(width: bounds.width, height: 45)
    flowLayout.footerReferenceSize = CGSize(width: bounds.width, height: 45)
    flowLayout.itemSize = CGSize(width: bounds.width - 40, height: 40)
    
    flowLayout.sectionInset = UIEdgeInsets.sameInset(inset: 10)
   
    flowLayout.sectionHeadersPinToVisibleBounds = true
    flowLayout.sectionFootersPinToVisibleBounds = true
    
    let collectionView = ListCollectionView(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.contentInset = UIEdgeInsets.sameInset(inset: 5)
    
    return collectionView
  }()
  
  private var viewModel: ListViewModelProtocol!
  
  
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
  
  private func configure() {
    addSubview(collectionView)

    configureCollectionView()
  }
  
  
  private func configureCollectionView() {    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.dragInteractionEnabled = true
    collectionView.dragDelegate = self
    collectionView.dropDelegate = self
    
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }
  
  func update(with viewModel: ListViewModelProtocol) {
    self.viewModel = viewModel
    
    collectionView.reloadData()
  }
}


// MARK: - Extension


// MARK: UITableView DataSource

extension BoardDetailCollectionViewCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfCards()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: ListCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    
    cell.update(with: viewModel.fetchCard(at: indexPath.row))
    
    return cell
  }
}


// MARK: UITableView Delegate

extension BoardDetailCollectionViewCell: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      let headerView: ListHeaderView = collectionView.dequeReusableHeaderView(forIndexPath: indexPath)
      return headerView
      
    case UICollectionView.elementKindSectionFooter:
      let footerView: ListFooterView = collectionView.dequeReusableFooterView(forIndexPath: indexPath)
      return footerView
      
    default:
      return UICollectionReusableView()
    }
  }
}


// MARK: UITableView Drag Delegate

extension BoardDetailCollectionViewCell: UICollectionViewDragDelegate {
  
  // 1. 드래깅 시작
  func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    let card = viewModel.fetchCard(at: indexPath.row)
    let itemProvider = NSItemProvider(object: card)
    
    let dragItem = UIDragItem(itemProvider: itemProvider)
    
    session.localContext = (viewModel, indexPath, collectionView)
    return [dragItem]
  }
}


// MARK: UITableView Drop Delegate

extension BoardDetailCollectionViewCell: UICollectionViewDropDelegate {
  
  // 2. 드래깅 중
  func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
    return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
  }
  
  // 3. 드래깅 끝
  func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    guard coordinator.session.hasItemsConforming(
            toTypeIdentifiers: [kUTTypeData as String])
    else { return }
    
    processDraggedItem(by: collectionView, and: coordinator)
  }
  
  func processDraggedItem(by collectionView: UICollectionView, and coordinator: UICollectionViewDropCoordinator) {
    
    // 드래그한 아이템의 객체를 비동기적으로 로드
    coordinator.session.loadObjects(ofClass: List.Card.self) { [self] item in
      guard let card = item.first as? List.Card else { return }
      
      let source = coordinator.items.first?.sourceIndexPath
      let destination = coordinator.destinationIndexPath
            
      switch (source, destination) {
      ///  ** 1. 같은 테이블뷰**
      case (.some(let sourceIndexPath), .some(let destinationIndexPath)):
        changeData(inSame: collectionView, about: card, by: sourceIndexPath, and: destinationIndexPath)
                
      /// **2. 다른 테이블뷰: cell 이 있는 테이블뷰에 삽입할 때(insert)**
      case (nil, .some(let destinationIndexPath)):
        let localContext = coordinator.session.localDragSession?.localContext
        
        insertData(with: localContext) {
          viewModel.insert(card: card, at: destinationIndexPath.row)
          
          let row = destinationIndexPath.row
          collectionView.insertItems(at: [IndexPath(row: row, section: 0)])
        }
                
      /// **3. 다른 테이블뷰: cell 이 없는 컬렉션뷰에 삽입할 때(append)**
      case (.some(_), nil):
        fallthrough
      case (nil, nil):
        let localContext = coordinator.session.localDragSession?.localContext
        
        insertData(with: localContext) {
          viewModel.append(card: card)
          
          let row = viewModel.numberOfCards()-1
          collectionView.insertItems(at: [IndexPath(row: row, section: 0)])
        }
      }
    }
  }
  
  func changeData(
    inSame collectionView: UICollectionView,
    about card: List.Card,
    by sourceIndexPath: IndexPath,
    and destinationIndexPath: IndexPath
  ) {
    let updatedIndexPaths = viewModel.makeUpdatedIndexPaths(by: sourceIndexPath, and: destinationIndexPath)
    
    viewModel.removeCard(at: sourceIndexPath.row)
    viewModel.insert(card: card, at: destinationIndexPath.row)
    
    collectionView.reloadItems(at: updatedIndexPaths)
  }
  
  func insertData(
    with localContext: Any?,
    _ insertDestinationTableViewDataHandler: () -> Void
  ) {
    removeSourceTableViewData(localContext: localContext)
    
    insertDestinationTableViewDataHandler()
  }
  
  func removeSourceTableViewData(localContext: Any?) {
    guard let (
            sourceViewModel,
            sourceIndexPath,
            collectionView) = localContext
            as? (
              ListViewModelProtocol,
              IndexPath,
              UICollectionView
            ) else { return }
    
    sourceViewModel.removeCard(at: sourceIndexPath.row)
    collectionView.reloadSections(IndexSet(integer: 0))
  }
}



