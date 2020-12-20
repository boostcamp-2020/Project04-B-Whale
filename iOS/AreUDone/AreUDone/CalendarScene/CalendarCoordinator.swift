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
  
  private let router: Routable
  
  private var storyboard: UIStoryboard {
    return UIStoryboard.load(storyboard: .calendar)
  }
  
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
            creator: { [weak self] coder in
              guard let self = self else { return UIViewController() }
              let cardService = CardService(router: self.router, localDataSource: CardLocalDataSource())
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
  
  func presentCalendarPicker(selectedDate: Date, delegate: CalendarPickerViewControllerDelegate) {
    calendarPickerCoordinator = CalendarPickerCoordinator(router: router, selectedDate: selectedDate)
    calendarPickerCoordinator.navigationController = navigationController
    
    guard let calendarPickerViewController = calendarPickerCoordinator.start()
            as? CalendarPickerViewController
    else { return }
    
    calendarPickerViewController.delegate = delegate
    navigationController?.present(calendarPickerViewController, animated: true)
  }
  
  func pushToCardDetail(for id: Int) {
    cardDetailCoordinator = CardDetailCoordinator(id: id, router: self.router)
    cardDetailCoordinator.navigationController = navigationController
    
    let cardDetailViewController = cardDetailCoordinator.start()
    cardDetailViewController.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(cardDetailViewController, animated: true)
  }
}
