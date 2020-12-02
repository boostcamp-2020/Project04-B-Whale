//
//  BoardDetailCoordinator.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import UIKit
import NetworkFramework

final class BoardDetailCoordinator: NavigationCoordinator {
  var navigationController: UINavigationController?
  
  private var storyboard: UIStoryboard {
    UIStoryboard.load(storyboard: .boardDetail)
  }
  private let boardId: Int
  
  init(boardId: Int) {
    self.boardId = boardId
  }
  
  
  func start() -> UIViewController {
    
    guard let boardDetailViewController = storyboard.instantiateViewController(
            identifier: BoardDetailViewController.identifier, creator: { [weak self] coder in
              guard let self = self else { return UIViewController()}
              
              let boardService = BoardService(router: MockRouter(jsonFactory: BoardDetailTrueJsonFactory()))
              let activityService = ActivityService(router: MockRouter(jsonFactory: ActivityTrueJsonFactory()))
              
              let boardDetailViewModel = BoardDetailViewModel(boardService: boardService, boardId: self.boardId)
              
              let sideBarViewModel = SideBarViewModel(
                boardService: boardService,
                activityService: activityService,
                boardId: self.boardId
              )
              let sideBarViewController = SideBarViewController(
                nibName: SideBarViewController.identifier,
                bundle: nil,
                viewModel: sideBarViewModel
              )
              
              return BoardDetailViewController(
                coder: coder,
                viewModel: boardDetailViewModel,
                sideBarViewController: sideBarViewController
              )
            }) as? BoardDetailViewController else { return UIViewController() }
    
    boardDetailViewController.coordinator = self
    
    return boardDetailViewController
  }
}

extension BoardDetailCoordinator {
  
  func pop() {
    navigationController?.popViewController(animated: true)
  }
}

