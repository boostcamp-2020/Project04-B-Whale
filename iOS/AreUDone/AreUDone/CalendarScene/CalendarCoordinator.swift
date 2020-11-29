//
//  CalendarCoordinator.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/21.
//

import UIKit
import NetworkFramework

final class CalendarCoordinator: NavigationCoordinator {
  
  // MARK: - Property
  private var storyboard: UIStoryboard {
    return UIStoryboard.load(storyboard: .calendar)
  }
  private let router: Routable
  private var navigationController: UINavigationController!
  var calendarViewController: CalendarViewController!
  
  
  // MARK: - Initializer
  
  init(router: Routable) {
    self.router = router
  }
 
  // MARK: - Method
  
  func setNavigationController(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() -> UIViewController {
    calendarViewController = storyboard.instantiateViewController(
            identifier: CalendarViewController.identifier,
            creator: { coder in
              let cardService = CardService(router: MockRouter(jsonFactory: CardTrueJsonFactory())) // TODO: CardTrueJsonFactory 라고 프로그래머가 구별해서 넣어줘야 하는게 살짝 불편한데... 
              let viewModel = CalendarViewModel(cardService: cardService)
              return CalendarViewController(coder: coder, viewModel: viewModel)
            }) as? CalendarViewController
    
    
    calendarViewController.calendarCoordinator = self
    
    return calendarViewController
  }
}

extension CalendarCoordinator {
  
  func didTapOnDate(selectedDate: Date) {
    let calendarPickerCoordinator = CalendarPickerViewCoordinator(selectedDate: selectedDate)
    
    let calendarPickerViewController = calendarPickerCoordinator.start()
    navigationController.present(calendarPickerViewController, animated: true)
  }
  
  func showCardDetail(for id: Int) {
    let router = Router()
    let cardDetailCoordinator = CardDetailCoordinator(id: id, router: router)
    
    let cardDetailViewController = cardDetailCoordinator.start()
    navigationController.pushViewController(cardDetailViewController, animated: true)
  }
}
