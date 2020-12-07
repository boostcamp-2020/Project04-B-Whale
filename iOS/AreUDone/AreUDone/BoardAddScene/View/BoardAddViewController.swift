//
//  BoardAddViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/07.
//

import UIKit

final class BoardAddViewController: UIViewController {
  
  // MARK: - Property
  
  weak var coordinator: BoardAddCoordinator?
  private let viewModel: BoardAddViewModelProtocol

  @IBOutlet private weak var tableView: BoardAddTableView! {
    didSet {
      tableView.dataSource = dataSource
    }
  }
  private var rightBarButtonItem: UIBarButtonItem!
  private lazy var dataSource = BoardAddTableViewDataSource(viewModel: viewModel)
  
  
  // MARK: - Initializer
  
  init?(coder: NSCoder, viewModel: BoardAddViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("This class should be initialized with code")
  }
  
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindUI()
    configure()
  }
}


// MARK: - Extension Configure Method

private extension BoardAddViewController {
  
  func configure() {
    configureView()
  }
  
  func configureView() {
    navigationItem.title = "보드 추가"
    navigationController?.navigationBar.titleTextAttributes = [
      NSAttributedString.Key.font: UIFont.nanumB(size: 20)
    ]

    let leftBarButtonItem = CustomBarButtonItem(imageName: "xmark") { [weak self] in
      self?.coordinator?.dismiss()
    }
    leftBarButtonItem.setColor(to: .black)
    
    rightBarButtonItem = UIBarButtonItem(
      title: "생성하기",
      style: .plain,
      target: self,
      action: #selector(createButtonTapped)
    )
    rightBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.nanumR(size: 18)], for: .normal)
    rightBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.nanumR(size: 18)], for: .disabled)
    rightBarButtonItem.isEnabled = false
    
    navigationItem.leftBarButtonItem = leftBarButtonItem
    navigationItem.rightBarButtonItem = rightBarButtonItem
  }
  
  @objc func createButtonTapped() {
    viewModel.createBoard()
  }
}


// MARK: - Extension bindUI

extension BoardAddViewController {
  
  func bindUI() {
    viewModel.bindingIsCreateEnable { [weak self] bool in
      self?.rightBarButtonItem.isEnabled = bool
    }
   
    viewModel.bindingUpdateBoardColor { [weak self] colorAsString in
      guard let cell =
              self?.tableView.cellForRow(at: IndexPath(row: 1, section: 0))
              as? BoardColorTableViewCell else { return }
      cell.update(with: colorAsString)
    }
    
    viewModel.bindingDismiss { [weak self] in
      self?.coordinator?.dismiss()
    }
  }
}
