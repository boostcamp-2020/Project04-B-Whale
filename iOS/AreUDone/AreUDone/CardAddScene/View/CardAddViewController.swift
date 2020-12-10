//
//  CardAddViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/10.
//

import UIKit

final class CardAddViewController: UIViewController {
  
  // MARK: - Property
  
  weak var coordinator: CardAddCoordinator?
  private let viewModel: CardAddViewModelProtocol

  @IBOutlet private weak var tableView: CardAddTableView! {
    didSet {
      tableView.dataSource = dataSource
    }
  }
  
  private var rightBarButtonItem: UIBarButtonItem!
  private lazy var dataSource = CardAddTableViewDataSource(viewModel: viewModel)
  
  
  // MARK: - Initializer
  
  init?(coder: NSCoder, viewModel: CardAddViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("This class should be initialized with code")
  }
  
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    bindUI()
    configure()
  }
}


// MARK: - Extension Configure Method

private extension CardAddViewController {
  
  func configure() {
    configureView()
  }
  
  func configureView() {
    
  }
}


