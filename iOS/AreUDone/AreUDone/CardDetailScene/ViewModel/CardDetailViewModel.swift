//
//  CardDetailViewModel.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/25.
//

import Foundation

protocol CardDetailViewModelProtocol {
  func bindingCardDetailContentView(handler: @escaping ((String) -> Void))
  func bindingCardDetailDueDateView(handler: @escaping ((String) -> Void))
  func bindingCardDetailCommentTableView(handler: @escaping (([Comment]) -> Void))
  
  func fetchDetailCard()
}

final class CardDetailViewModel: CardDetailViewModelProtocol {
  
  // MARK:- Property
  
  private var cardService: CardServiceProtocol
  private let id: Int
  
  private var cardDetailContentViewHandler: ((String) -> Void)?
  private var cardDetailDueDateViewHandler: ((String) -> Void)?
  private var cardDetailCommentsViewHandler: (([Comment]) -> Void)?
  
  // MARK:- Initializer
  
  init(id: Int, cardService: CardServiceProtocol) {
    self.id = id
    self.cardService = cardService
  }
  
  
  func bindingCardDetailContentView(handler: @escaping ((String) -> Void)) {
    cardDetailContentViewHandler = handler
  }
  
  func bindingCardDetailDueDateView(handler: @escaping ((String) -> Void)) {
    cardDetailDueDateViewHandler = handler
  }
  
  func bindingCardDetailCommentTableView(handler: @escaping (([Comment]) -> Void)) {
    cardDetailCommentsViewHandler = handler
  }
  
  func fetchDetailCard() {
    let content = """
                  안녕하세요
                  안녕하세요
                  """
    
    let dueDate = "2020-11-26"
    
    let user1 = User(id: 0, name: "서명렬", profileImageUrl: "")
    let user2 = User(id: 1, name: "심영민", profileImageUrl: "")
    
    let comment1 = Comment(id: 0, content: "안녕하세요", createdAt: "2020-11-26", user: user1)
    let comment2 = Comment(id: 1, content: "안녕하세요", createdAt: "2020-11-26", user: user2)
    let comment3 = Comment(id: 2, content: "안녕하세요", createdAt: "2020-11-26", user: user2)
    let comment4 = Comment(id: 3, content: "안녕하세요", createdAt: "2020-11-26", user: user2)
    let comment5 = Comment(id: 4, content: "안녕하세요", createdAt: "2020-11-26", user: user2)
    let comment6 = Comment(id: 5, content: "안녕하세요", createdAt: "2020-11-26", user: user2)
    let comment7 = Comment(id: 6, content: "안녕하세요", createdAt: "2020-11-26", user: user2)
    let comment8 = Comment(id: 7, content: "안녕하세요", createdAt: "2020-11-26", user: user2)
    
    cardDetailContentViewHandler?(content)
    cardDetailDueDateViewHandler?(dueDate)
    cardDetailCommentsViewHandler?([comment1, comment2, comment3, comment4, comment5, comment6, comment7, comment8])
  }
}
