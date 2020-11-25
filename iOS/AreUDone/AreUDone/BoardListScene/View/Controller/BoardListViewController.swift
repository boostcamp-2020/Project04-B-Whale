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
    
  }
  
  
  // MARK: - Method
  
  
}
