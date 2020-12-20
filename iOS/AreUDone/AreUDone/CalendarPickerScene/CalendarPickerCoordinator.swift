//
//  CalendarPickerCoordinator.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/24.
//

import UIKit
import NetworkFramework

final class CalendarPickerCoordinator: NavigationCoordinator {
  
  // MARK:- Property
  
  let router: Routable
  
  var navigationController: UINavigationController?
  private let selectedDate: Date
  
  
  // MARK:- Initializer
  
  init(router: Routable, selectedDate: Date) {
    self.router = router
    self.selectedDate = selectedDate
  }
  
  
  // MARK:- Method
  
  func start() -> UIViewController {
    let cardService = CardService(router: router)
    let viewModel = CalendarPickerViewModel(cardService: cardService)
    viewModel.selectedDate = selectedDate
    
    let calendarPickerViewController = CalendarPickerViewController(viewModel: viewModel)
    calendarPickerViewController.coordinator = self
    calendarPickerViewController.modalPresentationStyle = .overCurrentContext
    calendarPickerViewController.modalTransitionStyle = .crossDissolve
    
    return calendarPickerViewController
  }
}


// MARK:- Extension

extension CalendarPickerCoordinator {
  
  func dismiss() {
    navigationController?.dismiss(animated: true)
  }
}

