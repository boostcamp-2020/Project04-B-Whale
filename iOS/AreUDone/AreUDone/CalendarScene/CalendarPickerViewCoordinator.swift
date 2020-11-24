//
//  CalendarPickerViewCoordinator.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/24.
//

import UIKit

final class CalendarPickerViewCoordinator: Coordinator {
  func start() -> UIViewController {
    let calendarPickerViewController = CalendarPickerViewController(baseDate: Date(), selectedDateChanged: { date in
      print(date)
    })
    
    return calendarPickerViewController
  }
}
