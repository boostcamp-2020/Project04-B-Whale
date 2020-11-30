//
//  BoardDetailCollectionViewCell.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import UIKit
import MobileCoreServices

final class BoardDetailCollectionViewCell: UICollectionViewCell, Reusable {
  
  enum Section {
    case main
  }
  
  typealias DataSource = UICollectionViewDiffableDataSource<Section, Card>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Card>
  
  lazy var collectionView: ListCollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = CGSize(width: bounds.width, height: 40)
  
    let collectionView = ListCollectionView(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.collectionViewLayout = flowLayout
    return collectionView
  }()
  lazy var dataSource = configureDataSource()
  
  
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
    configureDropDrag()
    
    let cards = [
      Card(id: 0, title: "카드1", dueDate: "날짜1", position: 0, commentCount: 0),
      Card(id: 1, title: "카드2", dueDate: "날짜2", position: 0, commentCount: 0)
    ]
    updateSnapshot(with: cards)
  }
  
  private func configureCollectionView() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }
  
  private func configureDropDrag() {
    collectionView.dragInteractionEnabled = true
    collectionView.dragDelegate = self
    collectionView.dropDelegate = self
  }
  
  func update(with cards: [Card]) {
    updateSnapshot(with: cards, animatingDifferences: true)
  }
}


// MARK: - Extension


// MARK: Drag Delegate

extension BoardDetailCollectionViewCell: UICollectionViewDragDelegate {

  func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    print("드래깅 시작")
    let cards = dataSource.snapshot().itemIdentifiers(inSection: .main)
    let cardString = cards[indexPath.item].title.data(using: .utf8)
//    let itemProvider = NSItemProvider(object: car)
    let itemProvider = NSItemProvider(item: cardString! as NSData, typeIdentifier: kUTTypePlainText as String)
    let dragItem = UIDragItem(itemProvider: itemProvider)
    session.localContext = collectionView
    
    return [dragItem]
  }
}


// MARK: Drop Delegate

extension BoardDetailCollectionViewCell: UICollectionViewDropDelegate {

  func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    print("드래깅 끝(드롭)")

  }
  
  func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
    print("드래깅중")
    return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
  }
  


}


// MARK: Diffable DataSource

extension BoardDetailCollectionViewCell {
  
  func configureDataSource() -> DataSource {
    let dataSource = DataSource(
      collectionView: collectionView
    ) { (collectionView, indexPath, card) -> UICollectionViewCell? in
      let cell: ListCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      
      cell.backgroundColor = .darkGray
      cell.update(with: card)
      
      return cell
    }
    
    return dataSource
  }
  
  func updateSnapshot(with items: [Card], animatingDifferences: Bool = true) {
    var snapshot = Snapshot()
    
    snapshot.appendSections([.main])
    snapshot.appendItems(items)
    
    DispatchQueue.main.async {
      self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
  }
}
