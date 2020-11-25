//
//  BoardListCoordinator.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import UIKit
import NetworkFramework

class BoardListCoordinator: NavigationCoordinator {
  
  // MARK: - Property
  
  private var storyboard: UIStoryboard {
    return UIStoryboard.load(storyboard: .boardList)
  }
  private let router: Routable
  
  var navigationController: UINavigationController?
  
  
  // MARK: - Initializer
  
  init(router: Routable) {
    self.router = router
  }
  
  
  // MARK: - Method
  
  func start() -> UIViewController {
    
    guard let boardListViewController = storyboard.instantiateViewController(
            identifier: BoardListViewController.identifier, creator: { coder in
              let boardService = BoardService(router: self.router)
      let viewModel = BoardListViewModel(boardService: boardService)
      return BoardListViewController(coder: coder, viewModel: viewModel)
    }) as? BoardListViewController else { return UIViewController() }

    boardListViewController.coordinator = self

    return boardListViewController
  }
}


