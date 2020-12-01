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
  
  private var content: String
  
  private var initializeContentHandler: ((String) -> Void)?
  
  init(content: String) {
    self.content = content
  }
  
  func initailizeContent() {
    initializeContentHandler?(content)
  }
}


extension ContentInputViewModel {
  
  func bindingInitializeContent(handler: @escaping ((String) -> Void)) {
    initializeContentHandler = handler
  }
}
