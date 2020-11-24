//
//  CalendarPickerViewCoordinator.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/24.
//

import UIKit

final class CalendarPickerViewCoordinator: Coordinator {
  
  private let selectedDate: Date
  
  init(selectedDate: Date) {
    self.selectedDate = selectedDate
  }
  
  func start() -> UIViewController {
    let viewModel = CalendarPickerViewModel()
    viewModel.selectedDate = selectedDate
    
    let calendarPickerViewController = CalendarPickerViewController(viewModel: viewModel, selectedDateChanged: { date in
      print(date)
    })
    
    return calendarPickerViewController
  }
}
