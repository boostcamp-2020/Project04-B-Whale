//
//  BoardDetailCoordinator.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import UIKit

final class BoardDetailCoordinator: NavigationCoordinator {
  var navigationController: UINavigationController?
  
  private var storyboard: UIStoryboard {
    UIStoryboard.load(storyboard: .boardDetail)
  }
  
  
  func start() -> UIViewController {
    
    guard let boardDetailViewController = storyboard.instantiateViewController(
            identifier: BoardDetailViewController.identifier, creator: { coder in
              let boardService = BoardService(router: MockRouter(jsonFactory: BoardListTrueJsonFactory()))
      let viewModel = BoardDetailViewModel(boardService: boardService)
      return BoardDetailViewController(coder: coder, viewModel: viewModel)
    }) as? BoardDetailViewController else { return UIViewController() }
    
    boardDetailViewController.coordinator = self
    
    return boardDetailViewController
  }
}


