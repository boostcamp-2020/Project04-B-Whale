//
//  CardDetailCoordinator.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/25.
//

import UIKit
import NetworkFramework

final class CardDetailCoordinator: NavigationCoordinator {
  
  // MARK:- Property
  
  var navigationController: UINavigationController?
  private var storyboard: UIStoryboard {
    return UIStoryboard.load(storyboard: .cardDetail)
  }
  private let router: Routable
  private let id: Int
  
  
  // MARK:- Initializer
  
  init(id: Int, router: Routable) {
    self.id = id
    self.router = router
  }
  
  // TODO:- navi 쓸지 결정
  
  // MARK:- Method
  
  func start() -> UIViewController {
    guard let cardDetailViewController = storyboard.instantiateViewController(
            identifier: CardDetailViewController.identifier,
            creator: { [weak self] coder in
              guard let self = self else { return UIViewController() }
              let service = CardService(router: MockRouter(jsonFactory: CardTrueJsonFactory()))
              let viewModel = CardDetailViewModel(id: self.id, cardService: service)
              
              return CardDetailViewController(
                coder: coder,
                viewModel: viewModel
              )}) as? CardDetailViewController
    else { return UIViewController() }
    
    cardDetailViewController.cardDetailCoordinator = self
    
    return cardDetailViewController
  }
}


extension CardDetailCoordinator {
  
  func showContentInput(with content: String) {
    let contentInputCoordinator = ContentInputCoordinator(content: content)
    let contentInputViewController = contentInputCoordinator.start()

    navigationController?.pushViewController(
      contentInputViewController,
      animated: true
    )
  }
}
