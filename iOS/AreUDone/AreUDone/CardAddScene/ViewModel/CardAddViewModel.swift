//
//  CardAddViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/10.
//

import Foundation
import RealmSwift

protocol CardAddViewModelProtocol {
  
  func bindingIsCreateEnable(handler: @escaping (Bool) -> Void)
  func bindingUpdateTableView(handler: @escaping () -> Void)
  
  func bindingPresentCalendar(handler: @escaping (String) -> Void)
  func bindingPushContentInput(handler: @escaping (String) -> Void)
  func bindingPop(handler: @escaping () -> Void)

  func createCard()

  func fetchDate(handler: (String) -> Void)
  func fetchContent(handler: (String) -> Void)

  func updateCardTitle(to title: String)
  func updateSelectedDate(to dateString: String)
  func updateContent(to content: String)

  func presentCalendar()
  func pushContentInput()
}

final class CardAddViewModel: CardAddViewModelProtocol {
  
  // MARK: - Property
  
  private let realm = try! Realm()
  
  private let cardService: CardServiceProtocol
  private let viewModel: ListViewModelProtocol
  
  private var isCreateEnableHandler: ((Bool) -> Void)?
  private var updateTableViewHandler: (() -> Void)?

  private var presentCalendarHandler: ((String) -> Void)?
  private var pushContentInputHandler: ((String) -> Void)?
  private var popHandler: (() -> Void)?
  
  private var cardTitle: String = "" {
    didSet {
      check(title: cardTitle)
    }
  }
  private var selectedDate: Date = Date()
  private var content: String = ""
  
  
  // MARK: - Initializer
  
  init(cardService: CardServiceProtocol, viewModel: ListViewModelProtocol) {
    self.cardService = cardService
    self.viewModel = viewModel
  }
  
  
  // MARK: - Method
  
  func createCard() {
    let dateString = selectedDate.toStringWithTime()
    let listId = viewModel.fetchListId()
    cardService.createCard(
      listId: listId,
      title: cardTitle,
      dueDate: dateString,
      content: content
    ) { result in
      switch result {
      case .success(let card):
        self.realm.writeOnMain {
          self.viewModel.append(card: card)
          self.viewModel.updateTableView()

          self.popHandler?()
        }
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func fetchDate(handler: (String) -> Void) {
    let dateString = selectedDate.toStringWithTime()
    handler(dateString)
  }
  
  func fetchContent(handler: (String) -> Void) {
    handler(content)
  }
  
  func updateCardTitle(to title: String) {
    let trimmedTitle = title.trimmed
    cardTitle = trimmedTitle
  }
  
  func updateSelectedDate(to dateString: String) {
    selectedDate = dateString.toDateAndTimeFormat()
    updateTableViewHandler?()
  }
  
  func updateContent(to content: String) {
    self.content = content
    updateTableViewHandler?()
  }
  
  func presentCalendar() {
    presentCalendarHandler?(Date().toStringWithTime())
  }
  
  func pushContentInput() {
    pushContentInputHandler?(content)
  }
}


// MARK: - Extension

private extension CardAddViewModel {
  
  func check(title: String) {
    if title.isEmpty {
      isCreateEnableHandler?(false)
    } else {
      isCreateEnableHandler?(true)
    }
  }
}


// MARK: - Extension BindUI

extension CardAddViewModel {
  
  func bindingIsCreateEnable(handler: @escaping (Bool) -> Void) {
    isCreateEnableHandler = handler
  }
  
  func bindingUpdateTableView(handler: @escaping () -> Void) {
    updateTableViewHandler = handler
  }
  
  func bindingPresentCalendar(handler: @escaping (String) -> Void) {
    presentCalendarHandler = handler
  }
  
  func bindingPushContentInput(handler: @escaping (String) -> Void) {
    pushContentInputHandler = handler
  }
  
  func bindingPop(handler: @escaping () -> Void) {
    popHandler = handler
  }
}

