//
//  ContentInputCoordinator.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/01.
//

import UIKit
import NetworkFramework

final class ContentInputCoordinator: NavigationCoordinator {
  
  // MARK:- Property
  
  private var storyboard: UIStoryboard {
    return UIStoryboard.load(storyboard: .contentInput)
  }
  
  var navigationController: UINavigationController?
  
  private let content: String
  private let router: Routable
  
  // MARK:- Initializer
  
  init(content: String, router: Routable) {
    self.router = router
    self.content = content
  }
  
  
  // MARK:- Method
  
  func start() -> UIViewController {
    guard let contentInputViewController = storyboard.instantiateViewController(
            identifier: ContentInputViewController.identifier,
            creator: { [weak self] coder in
              guard let self = self else { return UIViewController() }
              let service = CardService(router: MockRouter(jsonFactory: CardTrueJsonFactory()))
              let viewModel = ContentInputViewModel(content: self.content, cardService: service)
              
              return ContentInputViewController(
                coder: coder,
                viewModel: viewModel
              )
            }) as? ContentInputViewController
    else { return UIViewController() }
    
    contentInputViewController.title = navigationController?.navigationBar.topItem?.title
    contentInputViewController.contentInputCoordinator = self
    
    return contentInputViewController
  }
}


extension ContentInputCoordinator {
  
  func dismiss() {
    navigationController?.popViewController(animated: true)
  }
}
