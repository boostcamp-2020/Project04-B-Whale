//
//  CalendarCoordinator.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/21.
//

import UIKit
import NetworkFramework

final class CalendarCoordinator: Coordinator {
  
  // MARK: - Property
  private var storyboard: UIStoryboard {
    return UIStoryboard.load(storyboard: .calendar)
  }
  private let router: Routable
  
  init(router: Routable) {
    self.router = router
  }
  
  // MARK: - Method
  
  func start() -> UIViewController {
    guard let calendarViewController = storyboard.instantiateViewController(
            identifier: CalendarViewController.identifier,
            creator: { coder in
              let cardService = CardService(router: MockRouter(jsonFactory: CardTrueJsonFactory())) // TODO: CardTrueJsonFactory 라고 프로그래머가 구별해서 넣어줘야 하는게 살짝 불편한데... 
              let viewModel = CalendarViewModel(cardService: cardService)
              return CalendarViewController(coder: coder, viewModel: viewModel)
            }) as? CalendarViewController
    else { return UIViewController() }
    
    calendarViewController.calendarCoordinator = self
    
    return calendarViewController
  }
}
