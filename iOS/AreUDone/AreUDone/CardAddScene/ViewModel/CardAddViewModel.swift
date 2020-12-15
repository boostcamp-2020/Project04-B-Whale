//
//  CardAddViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/10.
//

import Foundation
import RealmSwift

protocol CardAddViewModelProtocol {
  
  func bindingPop(handler: @escaping () -> Void)

  func bindingIsCreateEnable(handler: @escaping (Bool) -> Void)
  func bindingPresentCalendar(handler: @escaping (String) -> Void)
  func bindingPushContentInput(handler: @escaping (String) -> Void)
  func bindingUpdateTableView(handler: @escaping () -> Void)
  
  func updateListTitle(to title: String)
  
  func presentCalendar()
  func updateSelectedDate(to dateString: String)
  func fetchDate(handler: (String) -> Void)
  
  func pushContentInput()
  func updateContent(to content: String)
  func fetchContent(handler: (String) -> Void)
  
  func createCard()
}

final class CardAddViewModel: CardAddViewModelProtocol {
  
  // MARK: - Property
  
  private let realm = try! Realm()
  
  private let cardService: CardServiceProtocol
  private let viewModel: ListViewModelProtocol
  
  private var popHandler: (() -> Void)?
  private var isCreateEnableHandler: ((Bool) -> Void)?
  private var presentCalendarHandler: ((String) -> Void)?
  private var pushContentInputHandler: ((String) -> Void)?
  private var updateTableViewHandler: (() -> Void)?
  
  private var listTitle: String = "" {
    didSet {
      check(title: listTitle)
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
  
  func updateListTitle(to title: String) {
    listTitle = title
  }
  
  func presentCalendar() {
    presentCalendarHandler?(Date().toStringWithTime())
  }
  
  func updateSelectedDate(to dateString: String) {
    selectedDate = dateString.toDateAndTimeFormat()
    updateTableViewHandler?()
  }
  
  func fetchDate(handler: (String) -> Void) {
    let dateString = selectedDate.toStringWithTime()
    handler(dateString)
  }
  
  func pushContentInput() {
    pushContentInputHandler?(content)
  }
  
  func updateContent(to content: String) {
    self.content = content
    updateTableViewHandler?()
  }
  
  func fetchContent(handler: (String) -> Void) {
    handler(content)
  }
  
  func createCard() {
    let dateString = selectedDate.toStringWithTime()
    let listId = viewModel.fetchListId()
    cardService.createCard(
      listId: listId,
      title: listTitle,
      dueDate: dateString,
      content: content
    ) { result in
      switch result {
      case .success(let card):
        self.realm.writeOnMain {
          self.viewModel.append(card: card)
          self.viewModel.updateCollectionView()
          self.popHandler?()
        }
        
      case .failure(let error):
        print(error)
      }
    }
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

// MARK: - Extension UIBind

extension CardAddViewModel {
  
  func bindingPop(handler: @escaping () -> Void) {
    popHandler = handler
  }
  
  func bindingIsCreateEnable(handler: @escaping (Bool) -> Void) {
    isCreateEnableHandler = handler
  }
  
  func bindingPresentCalendar(handler: @escaping (String) -> Void) {
    presentCalendarHandler = handler
  }
  
  func bindingPushContentInput(handler: @escaping (String) -> Void) {
    pushContentInputHandler = handler
  }
  
  func bindingUpdateTableView(handler: @escaping () -> Void) {
    updateTableViewHandler = handler
  }
}

