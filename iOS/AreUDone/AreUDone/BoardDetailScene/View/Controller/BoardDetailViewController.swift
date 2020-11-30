//
//  BoardDetailViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import UIKit

final class BoardDetailViewController: UIViewController {
  
  enum Section {
    case main
  }
  
  typealias DataSource = UICollectionViewDiffableDataSource<Section, List>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, List>
  
  // MARK: - Property
  
  private let viewModel: BoardDetailViewModelProtocol
  weak var coordinator: BoardDetailCoordinator?
  
  @IBOutlet weak var collectionView: BoardDetailCollectionView!
  lazy var dataSource = configureDataSource()
  @IBOutlet private weak var collectionView: UICollectionView!
  private let pageControl: UIPageControl = {
    let pageControl = UIPageControl()
    
    pageControl.numberOfPages = 7
    
    return pageControl
  }()
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder, viewModel: BoardDetailViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindUI()
    configure()
    
    let cards = [
      Card(id: 1, title: "카드1", dueDate: "날짜1", position: 0, commentCount: 0),
      Card(id: 1, title: "카드2", dueDate: "날짜", position: 0, commentCount: 0)
    ]
    
    let cards2 = [
      Card(id: 1, title: "카드3", dueDate: "날짜1", position: 0, commentCount: 0),
      Card(id: 1, title: "카드4", dueDate: "날짜", position: 0, commentCount: 0)
    ]
    let items = [
      List(id: 0, title: "데이터1", position: 0, cards: cards),
      List(id: 1, title: "데이터2", position: 0, cards: cards2),
      List(id: 2, title: "데이터3", position: 0, cards: []),
      List(id: 3, title: "데이터3", position: 0, cards: []),
      List(id: 4, title: "데이터3", position: 0, cards: []),
      List(id: 5, title: "데이터3", position: 0, cards: []),
      List(id: 6, title: "데이터3", position: 0, cards: []),
      List(id: 7, title: "데이터3", position: 0, cards: [])
    ]
    updateSnapshot(with: items, animatingDifferences: false)
  }
}

// MARK: - Extension

extension BoardDetailViewController {
  
  func bindUI() {
    
  }
  
  func configure() {
    navigationItem.largeTitleDisplayMode = .never
  }
  
  func indexPath(of cell: UICollectionViewCell) -> IndexPath? {
    if let indexPath = collectionView.indexPath(for: cell) {
      return indexPath
    }
    return nil
  }
  
  func update(from sourceCell: UICollectionViewCell, _ sourceCards: [Card],
              to destinationCell: UICollectionViewCell, _ destinationCards: [Card]) {
    
    guard let sourceListIndexPath = collectionView.indexPath(for: sourceCell),
          let destinationListIndexPath = collectionView.indexPath(for: destinationCell)
    else { return }
    
    var lists = dataSource.snapshot().itemIdentifiers(inSection: .main)
    lists[sourceListIndexPath.item].cards = sourceCards
    lists[destinationListIndexPath.item].cards = destinationCards
    
    updateSnapshot(with: lists, animatingDifferences: false)
    print(sourceCards, destinationCards)
  }
}


// MARK: Diffable DataSource

extension BoardDetailViewController {
  
  func configureDataSource() -> DataSource {
    let dataSource = DataSource(
      collectionView: collectionView
    ) { (collectionView, indexPath, list) -> UICollectionViewCell? in
      let cell: BoardDetailCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      
      cell.backgroundColor = .gray
      
      cell.parentVc = self
      cell.update(with: list.cards)
      
      return cell
    }
    
    return dataSource
  }
  
  func updateSnapshot(with items: [List], animatingDifferences: Bool = true) {
    var snapshot = Snapshot()
    
    snapshot.appendSections([.main])
    snapshot.appendItems(items)
    
    DispatchQueue.main.async {
      self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
extension BoardDetailViewController {
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

    let offset = (
      layout.sectionInset.left
        + layout.itemSize.width
        + layout.minimumLineSpacing
        + layout.itemSize.width/2
    ) - (view.bounds.width/2)

    let index = scrollView.contentOffset.x / offset

    var renewedIndex: CGFloat
    if scrollView.contentOffset.x > targetContentOffset.pointee.x {
      renewedIndex = floor(index) // 왼쪽
    } else {
      renewedIndex = ceil(index)  // 오른쪽
    }

    targetContentOffset.pointee = CGPoint(x: renewedIndex * offset, y: 0)
    pageControl.currentPage = Int(renewedIndex)
  }
}
