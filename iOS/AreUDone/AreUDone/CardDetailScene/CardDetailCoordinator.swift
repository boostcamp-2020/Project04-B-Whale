//
//  CardDetailCoordinator.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/25.
//

import UIKit
import NetworkFramework

final class CardDetailCoordinator: NavigationCoordinator {
  
  // MARK:- Property
  
  var navigationController: UINavigationController?
  private var storyboard: UIStoryboard {
    return UIStoryboard.load(storyboard: .cardDetail)
  }
  private let router: Routable
  private let id: Int
  private var contentInputCoordinator: NavigationCoordinator!
  private var calendarPickerCoordinator: CalendarPickerViewCoordinator!
  private var memberUpdateCoordinator: MemberUpdateCoordinator!
  
  // MARK:- Initializer
  
  init(id: Int, router: Routable) {
    self.id = id
    self.router = router
  }
  
  // TODO:- navi 쓸지 결정
  
  // MARK:- Method
  
  func start() -> UIViewController {
    guard let cardDetailViewController = storyboard.instantiateViewController(
            identifier: CardDetailViewController.identifier,
            creator: { [weak self] coder in
              guard let self = self else { return UIViewController() }
              let cardService = CardService(router: MockRouter(jsonFactory: CardTrueJsonFactory()))
              let imageService = ImageService(router: self.router)
              let userService = UserService(router: MockRouter(jsonFactory: UserJsonFactory()))
              let viewModel = CardDetailViewModel(
                id: self.id,
                cardService: cardService,
                imageService: imageService,
                userService: userService
              )
              
              return CardDetailViewController(
                coder: coder,
                viewModel: viewModel
              )}) as? CardDetailViewController
    else { return UIViewController() }
    
    cardDetailViewController.cardDetailCoordinator = self
    
    return cardDetailViewController
  }
}


extension CardDetailCoordinator {
  
  func showContentInput(with content: String, delegate: ContentInputViewControllerDelegate) {
    contentInputCoordinator = ContentInputCoordinator(content: content, router: router)
    contentInputCoordinator.navigationController = navigationController
    guard let contentInputViewController = contentInputCoordinator.start()
            as? ContentInputViewController
    else { return }
    contentInputViewController.delegate = delegate
    
    navigationController?.pushViewController(
      contentInputViewController,
      animated: true
    )
  }
  
  func showCalendar(with stringToDate: String, delegate: CalendarPickerViewControllerDelegate) {
    let date = stringToDate.toDateFormat(with: .dash)
    calendarPickerCoordinator = CalendarPickerViewCoordinator(selectedDate: date)
    calendarPickerCoordinator.navigationController = navigationController
    
    guard let calendarPickerViewController = calendarPickerCoordinator.start()
            as? CalendarPickerViewController
    else { return }
    
    calendarPickerViewController.delegate = delegate
    navigationController?.present(calendarPickerViewController, animated: true)
  }
  
  func showMemberUpdate() {
    memberUpdateCoordinator = MemberUpdateCoordinator(router: router)
    memberUpdateCoordinator.navigationController = navigationController
    
    guard let memberUpdateViewController = memberUpdateCoordinator.start()
            as? MemberUpdateViewController
    else { return }
    
    navigationController?.present(memberUpdateViewController, animated: true)
  }
}
