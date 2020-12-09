//
//  BoardListCoordinator.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import UIKit
import NetworkFramework

final class BoardListCoordinator: NavigationCoordinator {
  
  // MARK: - Property
  
  private var storyboard: UIStoryboard {
    return UIStoryboard.load(storyboard: .boardList)
  }
  private let router: Routable
  
  var navigationController: UINavigationController?
  private var boardDetailCoordinator: NavigationCoordinator!
  private var boardAddCoordinator: NavigationCoordinator!
  
  // MARK: - Initializer
  
  init(router: Routable) {
    self.router = router
  }
  
  
  // MARK: - Method
  
  func start() -> UIViewController {
    
    guard let boardListViewController = storyboard.instantiateViewController(
            identifier: BoardListViewController.identifier, creator: { [weak self] coder in
              guard let self = self else { return UIViewController() }
              
              let boardService = BoardService(router: self.router)
              let viewModel = BoardListViewModel(boardService: boardService)
              return BoardListViewController(coder: coder, viewModel: viewModel, sectionFactory: SectionContentsFactory())
            }) as? BoardListViewController else { return UIViewController() }
    
    boardListViewController.coordinator = self
    
    return boardListViewController
  }
}


// MARK: - Extension

extension BoardListCoordinator {
  
  func pushToBoardDetail(boardId: Int) {
    boardDetailCoordinator = BoardDetailCoordinator(router: router, boardId: boardId)
    boardDetailCoordinator.navigationController = navigationController
    
    let viewController = boardDetailCoordinator.start()
    
    viewController.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(viewController, animated: true)
  }
  
  func presentBoardAdd() {
    boardAddCoordinator = BoardAddCoordinator(router: router)
    boardAddCoordinator.navigationController = navigationController
    
    let viewController = boardAddCoordinator.start()
    let subNavigationController = UINavigationController()
    subNavigationController.pushViewController(viewController, animated: true)
    
    subNavigationController.modalPresentationStyle = .fullScreen
    navigationController?.present(subNavigationController, animated: true)
  }
}
