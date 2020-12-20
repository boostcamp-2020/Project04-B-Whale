//
//  BoardAddCoordinator.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/07.
//

import UIKit
import NetworkFramework

final class BoardAddCoordinator: NavigationCoordinator {
  
  // MARK: - Property
  
  private var storyboard: UIStoryboard {
    return UIStoryboard.load(storyboard: .boardAdd)
  }
  private let router: Routable
  
  var navigationController: UINavigationController?
  
  
  // MARK: - Initializer
  
  init(router: Routable) {
    self.router = router
  }
  
  
  // MARK: - Method
  
  func start() -> UIViewController {
    
    guard let boardAddViewController = storyboard.instantiateViewController(
            identifier: BoardAddViewController.identifier, creator: { [weak self] coder in
              guard let self = self else { return UIViewController() }
              
              let boardService = BoardService(router: self.router, localDataSource: BoardLocalDataSource())
              let viewModel = BoardAddViewModel(boardService: boardService)
              return BoardAddViewController(coder: coder, viewModel: viewModel)
            }) as? BoardAddViewController else { return UIViewController() }
    
    boardAddViewController.coordinator = self
    
    return boardAddViewController
  }
}


// MARK: - Extension

extension BoardAddCoordinator {
  
  func dismiss() {
    navigationController?.dismiss(animated: true)
  }
}
