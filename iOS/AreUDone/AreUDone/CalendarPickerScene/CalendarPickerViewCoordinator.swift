//
//  CalendarPickerViewCoordinator.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/24.
//

import UIKit
import NetworkFramework

final class CalendarPickerViewCoordinator: NavigationCoordinator {
  
  private let selectedDate: Date
  var navigationController: UINavigationController?
  let router: Routable
  
  init(router: Routable, selectedDate: Date) {
    self.router = router
    self.selectedDate = selectedDate
  }
  
  func start() -> UIViewController {
    let cardService = CardService(router: router)
    let viewModel = CalendarPickerViewModel(cardService: cardService)
    viewModel.selectedDate = selectedDate
    
    let calendarPickerViewController = CalendarPickerViewController(viewModel: viewModel)
    calendarPickerViewController.coordinator = self

    return calendarPickerViewController
  }
}


extension CalendarPickerViewCoordinator {
  
  func dismiss() {
    navigationController?.dismiss(animated: true)
  }
}

