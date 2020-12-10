//
//  CardAddCoordinator.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/10.
//

import UIKit
import NetworkFramework

final class CardAddCoordinator: NavigationCoordinator {
  
  // MARK: - Property
  
  private var storyboard: UIStoryboard {
    return UIStoryboard.load(storyboard: .cardAdd)
  }
  private let router: Routable
  
  var navigationController: UINavigationController?
  
  
  // MARK: - Initializer
  
  init(router: Routable) {
    self.router = router
  }
  
  
  // MARK: - Method
  
  func start() -> UIViewController {
    
    guard let cardAddViewController = storyboard.instantiateViewController(
            identifier: CardAddViewController.identifier, creator: { [weak self] coder in
              guard let self = self else { return UIViewController() }
              
              let cardService = CardService(router: self.router)
              let viewModel = CardAddViewModel(cardService: cardService)
              return CardAddViewController(coder: coder, viewModel: viewModel)
            }) as? CardAddViewController else { return UIViewController() }
    
    cardAddViewController.coordinator = self
    
    return cardAddViewController
  }
}


// MARK: - Extension

extension CardAddCoordinator {
  
  func dismiss() {
    navigationController?.dismiss(animated: true)
  }
}

