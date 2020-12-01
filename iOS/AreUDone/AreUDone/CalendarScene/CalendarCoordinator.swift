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
  
  var navigationController: UINavigationController?
  
  private var calendarPickerCoordinator: NavigationCoordinator!
  private var cardDetailCoordinator: NavigationCoordinator!
  
  // MARK: - Initializer
  
  init(router: Routable) {
    self.router = router
  }
  
  
  // MARK: - Method
  
  func start() -> UIViewController {
    
    guard let calendarViewController = storyboard.instantiateViewController(
            identifier: CalendarViewController.identifier,
            creator: { coder in
              let cardService = CardService(router: MockRouter(jsonFactory: CardTrueJsonFactory()))
              let viewModel = CalendarViewModel(cardService: cardService)
              return CalendarViewController(coder: coder, viewModel: viewModel)
            }) as? CalendarViewController
    else { return UIViewController() }
    
    calendarViewController.calendarCoordinator = self
    
    return calendarViewController
  }
}


// MARK:- Extension

extension CalendarCoordinator {
  
  func didTapOnDate(selectedDate: Date, delegate: CalendarViewControllerDelegate) {
    calendarPickerCoordinator = CalendarPickerViewCoordinator(selectedDate: selectedDate)
    calendarPickerCoordinator.navigationController = navigationController
    
    guard let calendarPickerViewController = calendarPickerCoordinator.start()
            as? CalendarPickerViewController
    else { return }
    
    calendarPickerViewController.delegate = delegate
    navigationController?.present(calendarPickerViewController, animated: true)
  }
  
  func showCardDetail(for id: Int) {
    let router = Router()
    cardDetailCoordinator = CardDetailCoordinator(id: id, router: router)
    cardDetailCoordinator.navigationController = navigationController
    
    let cardDetailViewController = cardDetailCoordinator.start()
    cardDetailViewController.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(cardDetailViewController, animated: true)
  }
}
