//
//  BoardListViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import UIKit

class BoardListViewController: UIViewController {
  
  enum Section {
    case main
  }
  
  typealias DataSource = UICollectionViewDiffableDataSource<Section, Board>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Board>
  
  // MARK: - Property
  
  weak var coordinator: BoardListCoordinator?

  private let searchController: UISearchController = {
      let searchController = UISearchController(searchResultsController: nil)
      searchController.obscuresBackgroundDuringPresentation = false
      searchController.searchBar.placeholder = "보드 검색"
      return searchController
  }()
  
  @IBOutlet weak var collectionView: BoardListCollectionView!
  lazy var dataSource = configureDataSource()

  
  // MARK: - Initializer
  
  required init?(coder: NSCoder, viewModel: BoardListViewModelProtocol) {
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
    
    updateSnapshot()
  }
  
  
  // MARK: - Method
  
  
}


// MARK: - Extension

private extension BoardListViewController {
  
  func bindUI() {
    
  }
  
  func configure() {
    navigationItem.searchController = searchController
    searchController.searchResultsUpdater = self
  }
}


// MARK: Diffable DataSource

private extension BoardListViewController {
  
  func configureDataSource() -> DataSource {
    let dataSource = DataSource(
      collectionView: collectionView
    ) { (collectionView, indexPath, board) -> UICollectionViewCell? in
      let cell: BoardListCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      cell.updateCell(board: board)
      
      return cell
    }
    
    return dataSource
  }
  
  func updateSnapshot() {
    var snapshot = Snapshot()
    
    let boards = [Board(id: 1, title: "ddd")] // TODO: 임시 데이터 삭제 예정
    
    snapshot.appendSections([.main])
    snapshot.appendItems(boards)
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}


// MARK: UISearchResultsUpdating

extension BoardListViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
//    guard let searchKeyword = searchController.searchBar.text else { return }
  }
}
