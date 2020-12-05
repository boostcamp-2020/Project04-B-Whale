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
  private var invitationCoordinator: NavigationCoordinator!
  
  // TODO: Router 구체 타입이 아니라 이전 Coordinator 에서 넘겨주도록 변경
  //  private let router: Routable
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
              let imageService = ImageService(router: Router()) // TODO: Router 구체 타입이 아니라 이전 Coordinator 에서 넘겨주도록 변경
              
              let boardDetailViewModel = BoardDetailViewModel(boardService: boardService, boardId: self.boardId)
              
              let sideBarViewModel = SideBarViewModel(
                boardService: boardService,
                activityService: activityService,
                imageService: imageService,
                boardId: self.boardId,
                sideBarHeaderContentsFactory: SideBarHeaderContentsFactory()
              )
              let sideBarViewController = SideBarViewController(
                nibName: SideBarViewController.identifier,
                bundle: nil,
                viewModel: sideBarViewModel,
                coordinator: self
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
  
  func pushToInvitation() {
    invitationCoordinator = InvitationCoordinator()
    invitationCoordinator.navigationController = navigationController
    
    let viewController = invitationCoordinator.start()
    
    navigationController?.present(viewController, animated: true)
  }
}

