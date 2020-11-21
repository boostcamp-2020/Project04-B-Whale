//
//  CalendarCoordinator.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/21.
//

import UIKit

final class CalendarCoordinator: Coordinator {
  
  // MARK: - Property
  private var storyboard: UIStoryboard {
    return UIStoryboard.load(storyboard: .calendar)
  }
  
  
  // MARK: - Method
  
  func start() -> UIViewController {
    guard let calendarViewController = storyboard.instantiateViewController(
            identifier: CalendarViewController.identifier,
            creator: { coder in
              let viewModel = CalendarViewModel()
              return CalendarViewController(coder: coder, viewModel: viewModel)
            }) as? CalendarViewController
    else { return UIViewController() }
    
    calendarViewController.calendarCoordinator = self
    
    return calendarViewController
  }
}
