//
//  InvitationViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/05.
//

import UIKit

final class InvitationViewController: UIViewController {
  
  // MARK: property
  
  private var timer = Timer()
  
  private let viewModel: InvitationViewModelProtocol
  weak var coordinator: InvitationCoordinator?
  
  private let searchController: UISearchController = {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchBar.placeholder = "유저 검색"
    
    return searchController
  }()
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.dataSource = dataSource
      tableView.delegate = self
      tableView.register(InvitationTableViewCell.self)
    }
  }
  @IBOutlet weak var searchBarView: UIView! {
    didSet {
      searchBarView.addSubview(searchController.searchBar)
    }
  }
  private lazy var dataSource = InvitationTableViewDataSource(viewModel: viewModel)

  
  // MARK: - Initializer
  
  init?(coder: NSCoder, viewModel: InvitationViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("This class should be initialized with code")
  }
  
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    configure()
    bindUI()
  }
}


// MARK: - Extension Configure Method

private extension InvitationViewController {
  
  func configure() {
    view.addSubview(tableView)
    
    configureView()
    configureSearchController()
  }
  
  func configureView() {
    navigationItem.title = "초대하기"

    let barButtonItem = CustomBarButtonItem(imageName: "xmark") { [weak self] in
      self?.coordinator?.dismiss()
    }
    barButtonItem.setColor(to: .black)
    navigationItem.leftBarButtonItem = barButtonItem
  }
  
  func configureSearchController() {
    searchController.searchResultsUpdater = self
  }
}


// MARK: - Extension BindUI

private extension InvitationViewController {
  
  func bindUI() {
    viewModel.bindingUpdateInvitationTableView {
      self.tableView.reloadData()
    }
  }
}


// MARK: - Extension UISearchBarDelegate

extension InvitationViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchKeyword = searchController.searchBar.text,
          !searchKeyword.isEmpty else { return }
    
    debounce(time: 0.5) {
      self.viewModel.searchUser(of: searchKeyword)
    }
  }
  
  func debounce(time: TimeInterval, handler: @escaping () -> Void) {
    timer.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: time, repeats: false) { timer in
      handler()
    }
  }
}


// MARK: - Extension UITableViewDelegate

extension InvitationViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.addUserToBoard(of: indexPath.row)
  }
}
