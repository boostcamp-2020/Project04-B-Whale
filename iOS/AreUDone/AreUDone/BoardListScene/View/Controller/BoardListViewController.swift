//
//  BoardListViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import UIKit

class BoardListViewController: UIViewController {
  
  
  // MARK: - Property
  
  weak var coordinator: BoardListCoordinator?

  private let searchController: UISearchController = {
      let searchController = UISearchController(searchResultsController: nil)
      searchController.obscuresBackgroundDuringPresentation = false
      searchController.searchBar.placeholder = "보드 검색"
      return searchController
  }()

  
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


// MARK: UISearchResultsUpdating

extension BoardListViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    
    guard let searchKeyword = searchController.searchBar.text else { return }
  }
}
