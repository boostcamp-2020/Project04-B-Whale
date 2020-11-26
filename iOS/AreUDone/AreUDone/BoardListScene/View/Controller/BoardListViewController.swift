//
//  BoardListViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import UIKit

class BoardListViewController: UIViewController {
  
  enum Section {
    case my
    case invited
  }
  
  typealias DataSource = UICollectionViewDiffableDataSource<Section, Board>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Board>
  
  // MARK: - Property
  
  weak var coordinator: BoardListCoordinator?
  private let viewModel: BoardListViewModelProtocol
  private let sectionFactory: SectionContentsFactoryable
  
  private let searchController: UISearchController = {
      let searchController = UISearchController(searchResultsController: nil)
      searchController.obscuresBackgroundDuringPresentation = false
      searchController.searchBar.placeholder = "보드 검색"
      return searchController
  }()
  
  @IBOutlet weak var collectionView: BoardListCollectionView!
  lazy var dataSource = configureDataSource()
  
  
  // MARK: - Initializer
  
  required init?(
    coder: NSCoder,
    viewModel: BoardListViewModelProtocol,
    sectionFactory: SectionContentsFactoryable
  ) {
    
    self.viewModel = viewModel
    self.sectionFactory = sectionFactory
    
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
    
    dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
      let headerView: BoardListCollectionViewHeader = collectionView.dequeReusableHeaderView(forIndexPath: indexPath)
      
      headerView.titleLabel.text = self.sectionFactory.load(index: indexPath.section)
      return headerView
    }
    
    return dataSource
  }
  
  func updateSnapshot() {
    var snapshot = Snapshot()
    
    let myBoards = [Board(id: 1, title: "보드 제목1")] // TODO: 임시 데이터 삭제 예정
    let invitedBoards = [Board(id: 2, title: "보드 제목2"), Board(id: 3, title: "보드 제목3"),
                         Board(id: 4, title: "보드 제목4"), Board(id: 5, title: "보드 제목5"),
                         Board(id: 6, title: "보드 제목6"), Board(id: 7, title: "보드 제목7")] // TODO: 임시 데이터 삭제 예정
    
    
    snapshot.appendSections([.my, .invited])
    snapshot.appendItems(myBoards, toSection: .my)
    snapshot.appendItems(invitedBoards, toSection: .invited)
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}


// MARK: UISearchResultsUpdating

extension BoardListViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
//    guard let searchKeyword = searchController.searchBar.text else { return }
  }
}
