//
//  CardAddCoordinator.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/10.
//

import UIKit
import NetworkFramework

final class CardAddCoordinator: NavigationCoordinator {
  
  // MARK: - Property

  private let router: Routable
  private let viewModel: ListViewModelProtocol
  
  private var storyboard: UIStoryboard {
    return UIStoryboard.load(storyboard: .cardAdd)
  }

  var navigationController: UINavigationController?
  private var calendarPickerCoordinator: CalendarPickerViewCoordinator!
  private var contentInputCoordinator: NavigationCoordinator!
  

  // MARK: - Initializer
  
  init(router: Routable, viewModel: ListViewModelProtocol) {
    self.router = router
    self.viewModel = viewModel
  }
  
  
  // MARK: - Method
  
  func start() -> UIViewController {
    
    guard let cardAddViewController = storyboard.instantiateViewController(
            identifier: CardAddViewController.identifier, creator: { [weak self] coder in
              guard let self = self else { return UIViewController() }
              
              let cardService = CardService(router: self.router, localDataSource: CardLocalDataSource())
              let viewModel = CardAddViewModel(cardService: cardService, viewModel: self.viewModel)
              return CardAddViewController(coder: coder, viewModel: viewModel)
            }) as? CardAddViewController else { return UIViewController() }
    
    cardAddViewController.coordinator = self
    
    return cardAddViewController
  }
}


// MARK: - Extension

extension CardAddCoordinator {
  
  func dismiss() {
    navigationController?.dismiss(animated: true)
  }
  
  func presentCalendar(with dateString: String, delegate: CalendarPickerViewControllerDelegate) {
    let date = dateString.toDateAndTimeFormat()
    calendarPickerCoordinator = CalendarPickerCoordinator(router: router, selectedDate: date)
    calendarPickerCoordinator.navigationController = navigationController
    
    guard
      let calendarPickerViewController = calendarPickerCoordinator.start()
        as? CalendarPickerViewController
    else {
      return
      
    }
    
    calendarPickerViewController.delegate = delegate
    navigationController?.present(calendarPickerViewController, animated: true)
  }
  
  func pushContentInput(with content: String, delegate: ContentInputViewControllerDelegate) {
    contentInputCoordinator = ContentInputCoordinator(content: content, router: router)
    contentInputCoordinator.navigationController = navigationController
    
    guard
      let contentInputViewController = contentInputCoordinator.start()
            as? ContentInputViewController
    else {
      return
    }
    contentInputViewController.delegate = delegate
    
    navigationController?.pushViewController(
      contentInputViewController,
      animated: true
    )
  }
}

