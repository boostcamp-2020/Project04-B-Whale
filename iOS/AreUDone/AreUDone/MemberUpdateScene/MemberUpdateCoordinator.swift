//
//  MemberUpdateCoordinator.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/07.
//

import UIKit
import NetworkFramework

final class MemberUpdateCoordinator: NavigationCoordinator {
  
  // MARK:- Property
  
  var navigationController: UINavigationController?
  private var storyboard: UIStoryboard {
    return UIStoryboard.load(storyboard: .memberUpdate)
  }
  private let router: Routable
  
  private let cardId: Int
  private let boardId: Int
  private let cardMember: [User]?
  
  // MARK:- Initializer
  
  init(router: Routable, cardId: Int, boardId: Int, cardMember: [User]?) {
    self.router = router
    self.cardId = cardId
    self.boardId = boardId
    self.cardMember = cardMember
  }
  
  
  // MARK:- Method
  
  func start() -> UIViewController {
    guard let memberUpdateViewController = storyboard.instantiateViewController(
            identifier: MemberUpdateViewController.identifier,
            creator: { [weak self] coder in
              guard let self = self else { return UIViewController() }
              let cardService = CardService(router: MockRouter(jsonFactory: CardTrueJsonFactory()))
              let boardService = BoardService(router: MockRouter(jsonFactory: BoardDetailTrueJsonFactory()))
              let imageService = ImageService(router: self.router)
              let viewModel = MemberUpdateViewModel(
                cardId: self.cardId,
                boardId: self.boardId,
                cardMember: self.cardMember,
                boardService: boardService,
                imageService: imageService,
                cardService: cardService
              )
              
              return MemberUpdateViewController(
                coder: coder,
                viewModel: viewModel
              )
            }) as? MemberUpdateViewController
    else { return UIViewController() }
    
    memberUpdateViewController.coordinator = self
    
    return memberUpdateViewController
  }
}

extension MemberUpdateCoordinator {
  
  func dismiss() {
    navigationController?.dismiss(animated: true)
  }
}
