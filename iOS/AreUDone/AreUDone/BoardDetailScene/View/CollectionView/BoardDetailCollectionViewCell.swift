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
  weak var parentVc: BoardDetailViewController?
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    print("재사용")
  }
  
  // MARK: - Method
  
  private func configure() {
    addSubview(collectionView)
    
    configureCollectionView()
    configureDropDrag()
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
    print("호출")
    updateSnapshot(to: dataSource, with: cards, animatingDifferences: true)
  }
}


// MARK: - Extension


// MARK: Drag Delegate

extension BoardDetailCollectionViewCell: UICollectionViewDragDelegate {
  
  func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    print("드래깅 시작")
    let cards = dataSource.snapshot().itemIdentifiers(inSection: .main)
//    let cardString = cards[indexPath.item].title.data(using: .utf8)
    let itemProvider = NSItemProvider(object: cards[indexPath.item])
//    let itemProvider = NSItemProvider(item: cardString! as NSData, typeIdentifier: kUTTypePlainText as String)
    let dragItem = UIDragItem(itemProvider: itemProvider)
    session.localContext = (indexPath, dataSource, self)
    
    return [dragItem]
  }
}


// MARK: Drop Delegate

// viewmodel 넘겨줘서 여기서 갱신하도록
extension BoardDetailCollectionViewCell: UICollectionViewDropDelegate {
  
  func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    print("드래깅 끝(드롭)")
    
    guard coordinator.session.hasItemsConforming(
            toTypeIdentifiers: [kUTTypeData as String])
    else { return }
    
    
    // 드래그한 아이템의 객체를 비동기적으로 로드
    coordinator.session.loadObjects(ofClass: Card.self) { [self] item in
      
      guard let card = item.first as? Card else { return }
      print("통과")
      let source = coordinator.items.first?.sourceIndexPath
      let destination = coordinator.destinationIndexPath
    
      switch (source, destination) {
      
      // 같은 컬렉션뷰
      case (.some(let sourceIndexPath), .some(_)) :
        var cards = self.dataSource.snapshot().itemIdentifiers(inSection: .main)
        
        cards.remove(at: sourceIndexPath.item)
        cards.insert(card, at: 0)
      
        updateSnapshot(to: dataSource, with: cards)
        
      // cell 이 있는 컬렉션뷰에 삽입할 때
      case (nil, .some(let destinationIndexPath)):
        
        // 목적지: Destination Index
        let destinationCards = insertedDestinationCards(card: card, index: destinationIndexPath.item)
        updateSnapshot(to: dataSource, with: destinationCards)
        
        
        // 출발지: Source Index
        let localContext = coordinator.session.localDragSession?.localContext

        guard let (
          sourceIndexPath,
          sourceDataSource,
          sourceCell
        ) = localContext as? (
          IndexPath,
          DataSource,
          UICollectionViewCell
        ) else { return }
        
        let sourceCards = removedSourceCards(dataSource: sourceDataSource, index: sourceIndexPath.item)
        updateSnapshot(to: sourceDataSource, with: sourceCards)
        
        // 상위 컬렉션뷰 갱신
        parentVc?.update(from: sourceCell, sourceCards, to: self, destinationCards)
      
      // cell 이 없는 컬렉션뷰에 삽입할 때
      case (nil, nil):
        
        let destinationCards = appendedDestinationCards(card: card)
        updateSnapshot(to: dataSource, with: destinationCards)
        
        // 출발지: Source Index
        let localContext = coordinator.session.localDragSession?.localContext

        guard let (
          sourceIndexPath,
          sourceDataSource,
          sourceCell
        ) = localContext as? (
          IndexPath,
          DataSource,
          UICollectionViewCell
        ) else { return }
        
        let sourceCards = removedSourceCards(dataSource: sourceDataSource, index: sourceIndexPath.item)
        updateSnapshot(to: sourceDataSource, with: sourceCards)
        
        // 상위 컬렉션뷰 갱신
        parentVc?.update(from: sourceCell, sourceCards, to: self, destinationCards)
        
      default:
        break
      }
    }
  }
  
  func removedSourceCards(dataSource: DataSource, index: Int) -> [Card] {
    var sourceCards = dataSource.snapshot().itemIdentifiers(inSection: .main)
    
    sourceCards.remove(at: index)
    
    return sourceCards
  }
  
  func appendedDestinationCards(card: Card) -> [Card] {
    var destinationCards = self.dataSource.snapshot().itemIdentifiers(inSection: .main)
    destinationCards.append(card)
    
    return destinationCards
  }
  
  func insertedDestinationCards(card: Card, index: Int) -> [Card] {
    var destinationCards = self.dataSource.snapshot().itemIdentifiers(inSection: .main)
    
//    let card = Card(id: 0, title: string, dueDate: "", commentCount: 0)
    destinationCards.insert(card, at: index)
    
    return destinationCards
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
      
//      cell.addInteraction(UIDropInteraction(delegate: self))
      cell.backgroundColor = .darkGray
      cell.update(with: card)
      
      return cell
    }
    
    return dataSource
  }
  
  func updateSnapshot(to dataSource: DataSource, with items: [Card], animatingDifferences: Bool = true) {
    var snapshot = Snapshot()
    
    snapshot.appendSections([.main])
    snapshot.appendItems(items)
    
    DispatchQueue.main.async {
      dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
  }
}
