//
//  ContentInputViewModel.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/01.
//

import Foundation

protocol ContentInputViewModelProtocol {
  func bindingInitializeContent(handler: @escaping ((String) -> Void))
  
  func initailizeContent()
}

final class ContentInputViewModel: ContentInputViewModelProtocol {
  
  // MARK:- Property
  
  private var content: String
  private let cardService: CardServiceProtocol
  
  private var initializeContentHandler: ((String) -> Void)?
  
  
  // MARK:- Initializer
  
  init(content: String, cardService: CardServiceProtocol) {
    self.cardService = cardService
    self.content = content
  }
  
  
  // MARK:- Method
  
  func initailizeContent() {
    initializeContentHandler?(content)
  }
}


// MARK:- Extension bindUI

extension ContentInputViewModel {
  
  func bindingInitializeContent(handler: @escaping ((String) -> Void)) {
    initializeContentHandler = handler
  }
}
