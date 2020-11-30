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
    
    viewModel.initializeBoardListCollectionView()
  }
  
  
  // MARK: - Method
  
}


// MARK: - Extension

private extension BoardListViewController {
  
  func bindUI() {
    viewModel.bindingInitializeBoardListCollectionView { boards in
      self.updateSnapshot(with: boards, animatingDifferences: false)
    }
    
    viewModel.bindingUpdateBoardListCollectionView { boards in
      self.updateSnapshot(with: boards)
    }
  }
  
  func configure() {
    hidesBottomBarWhenPushed = true
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.title = "보드 목록"
    navigationItem.searchController = searchController
    searchController.searchResultsUpdater = self
    
    collectionView.delegate = self
    
  }
}


// MARK: Diffable DataSource

private extension BoardListViewController {
  
  func configureDataSource() -> DataSource {
    let dataSource = DataSource(
      collectionView: collectionView
    ) { (collectionView, indexPath, board) -> UICollectionViewCell? in
      let cell: BoardListCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      cell.update(with: board)
      
      return cell
    }
    
    dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
      let headerView: BoardListCollectionViewHeader = collectionView.dequeReusableHeaderView(forIndexPath: indexPath)
      
      headerView.titleLabel.text = self.sectionFactory.load(index: indexPath.section)
      return headerView
    }
    
    return dataSource
  }
  
  func updateSnapshot(with boards: Boards, animatingDifferences: Bool = true) {
    var snapshot = Snapshot()
  
    let myBoards = boards.myBoards
    let invitedBoards = boards.invitedBoards
    
    snapshot.appendSections([.my, .invited])
    snapshot.appendItems(myBoards, toSection: .my)
    snapshot.appendItems(invitedBoards, toSection: .invited)
    
    DispatchQueue.main.async {
      self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
  }
}

// MARK: UICollectionViewDelegate

extension BoardListViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    coordinator?.boardItemDidTapped()
  }
}


// MARK: UISearchResultsUpdating

extension BoardListViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
//    guard let searchKeyword = searchController.searchBar.text else { return }
  }
}
