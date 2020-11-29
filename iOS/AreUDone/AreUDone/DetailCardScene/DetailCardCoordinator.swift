//
//  DetailCardCoordinator.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/25.
//

import UIKit
import NetworkFramework

final class DetailCardCoordinator: NavigationCoordinator {
  
  // MARK:- Property
  
  var navigationController: UINavigationController?
  private var storyboard: UIStoryboard {
    return UIStoryboard.load(storyboard: .detailCard)
  }
  private let router: Routable
  private let id: Int
  
  func setNavigationController(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  
  // MARK:- Initializer
  
  init(id: Int, router: Routable) {
    self.id = id
    self.router = router
  }
  
  // TODO:- navi 쓸지 결정
  
  // MARK:- Method
  
  func start() -> UIViewController {
    guard let detailCalendarViewController = storyboard.instantiateViewController(
            identifier: DetailCardViewController.identifier, creator: { coder in
              let service = CardService(router: MockRouter(jsonFactory: CardTrueJsonFactory()))
              let viewModel = DetailCardViewModel(id: self.id, cardService: service)
              
              return DetailCardViewController(
                coder: coder,
                viewModel: viewModel
              )}) as? DetailCardViewController
    else { return UIViewController() }
    
    return detailCalendarViewController
  }
}
