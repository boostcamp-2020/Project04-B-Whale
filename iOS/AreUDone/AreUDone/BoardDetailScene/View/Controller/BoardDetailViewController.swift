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
    let items = Lists(lists: [
      List(id: 0, title: "데이터1", position: 0, cards: cards),
      List(id: 1, title: "데이터2", position: 0, cards: []),
      List(id: 2, title: "데이터3", position: 0, cards: []),
      List(id: 3, title: "데이터3", position: 0, cards: []),
      List(id: 4, title: "데이터3", position: 0, cards: []),
      List(id: 5, title: "데이터3", position: 0, cards: []),
      List(id: 6, title: "데이터3", position: 0, cards: []),
      List(id: 7, title: "데이터3", position: 0, cards: [])
    ])
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
}


// MARK: Diffable DataSource

extension BoardDetailViewController {
  
  func configureDataSource() -> DataSource {
    let dataSource = DataSource(
      collectionView: collectionView
    ) { (collectionView, indexPath, list) -> UICollectionViewCell? in
      let cell: BoardDetailCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      
      cell.backgroundColor = .gray
      cell.update(with: list.cards)
      
      return cell
    }
    
    return dataSource
  }
  
  func updateSnapshot(with items: Lists, animatingDifferences: Bool = true) {
    var snapshot = Snapshot()
    
    snapshot.appendSections([.main])
    snapshot.appendItems(items.lists)
    
    DispatchQueue.main.async {
      self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
  }
}
