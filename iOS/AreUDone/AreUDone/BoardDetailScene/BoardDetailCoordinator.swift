//
//  BoardDetailCoordinator.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import UIKit
import NetworkFramework

final class BoardDetailCoordinator: NavigationCoordinator {
  
  // MARK: - Property
  
  var navigationController: UINavigationController?
  private var invitationCoordinator: NavigationCoordinator!
  private var cardDetailCoordinator: NavigationCoordinator!

  private let boardId: Int
  private let router: Routable
  
  private var storyboard: UIStoryboard {
    UIStoryboard.load(storyboard: .boardDetail)
  }
  
  
  // MARK: - Initializer
  
  init(router: Routable, boardId: Int) {
    self.router = router
    self.boardId = boardId
  }
  
  
  // MARK: - Method
  
  func start() -> UIViewController {
    guard let boardDetailViewController = storyboard.instantiateViewController(
            identifier: BoardDetailViewController.identifier, creator: { [weak self] coder in
              guard let self = self else { return UIViewController()}
              
              let boardService = BoardService(router: self.router)
              let listService = ListService(router: self.router)
              let cardService = CardService(router: self.router)
              let activityService = ActivityService(router: MockRouter(jsonFactory: ActivityTrueJsonFactory()))
              let imageService = ImageService(router: self.router)
              
              let boardDetailViewModel = BoardDetailViewModel(
                boardService: boardService,
                listService: listService,
                cardService: cardService,
                boardId: self.boardId
              )
              
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


// MARK: - Extension

extension BoardDetailCoordinator {
  
  func pop() {
    navigationController?.popViewController(animated: true)
  }
  
  func pushToInvitation(delegate: InvitationViewControllerDelegate) {
    invitationCoordinator = InvitationCoordinator(router: router, boardId: boardId, delegate: delegate)
    invitationCoordinator.navigationController = navigationController
    
    let viewController = invitationCoordinator.start()
    let subNavigationController = UINavigationController()
    subNavigationController.pushViewController(viewController, animated: true)
    
    navigationController?.present(subNavigationController, animated: true)
  }
  
  func pushToCardDetail(of cardId: Int) {
    cardDetailCoordinator = CardDetailCoordinator(id: cardId, router: self.router)
    cardDetailCoordinator.navigationController = navigationController
    
    let cardDetailViewController = cardDetailCoordinator.start()
    cardDetailViewController.hidesBottomBarWhenPushed = true
    
    navigationController?.pushViewController(cardDetailViewController, animated: true)
  }
}


