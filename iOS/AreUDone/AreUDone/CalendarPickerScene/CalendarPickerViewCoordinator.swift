//
//  CalendarPickerViewCoordinator.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/24.
//

import UIKit

final class CalendarPickerViewCoordinator: NavigationCoordinator {
  
  private let selectedDate: Date
  var navigationController: UINavigationController?
  
  init(selectedDate: Date) {
    self.selectedDate = selectedDate
  }
  
  func start() -> UIViewController {
    let viewModel = CalendarPickerViewModel()
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
