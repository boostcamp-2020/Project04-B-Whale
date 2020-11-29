//
//  DetailCardViewModel.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/25.
//

import Foundation

protocol DetailCardViewModelProtocol {
  func bindingDetailCardContentView(handler: @escaping ((String) -> Void))
  func bindingDetailCardDueDateView(handler: @escaping ((String) -> Void))
  func bindingDetailCardCommentTableView(handler: @escaping (([Comment]) -> Void))
  
  func fetchDetailCard()
}

final class DetailCardViewModel: DetailCardViewModelProtocol {
  
  // MARK:- Property
  
  private var cardService: CardServiceProtocol
  private let id: Int
  
  private var detailCardContentViewHandler: ((String) -> Void)?
  private var detailCardDueDateViewHandler: ((String) -> Void)?
  private var detailCardCommentsViewHandler: (([Comment]) -> Void)?
  
  // MARK:- Initializer
  
  init(id: Int, cardService: CardServiceProtocol) {
    self.id = id
    self.cardService = cardService
  }
  
  
  func bindingDetailCardContentView(handler: @escaping ((String) -> Void)) {
    detailCardContentViewHandler = handler
  }
  
  func bindingDetailCardDueDateView(handler: @escaping ((String) -> Void)) {
    detailCardDueDateViewHandler = handler
  }
  
  func bindingDetailCardCommentTableView(handler: @escaping (([Comment]) -> Void)) {
    detailCardCommentsViewHandler = handler
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
    
    detailCardContentViewHandler?(content)
    detailCardDueDateViewHandler?(dueDate)
    detailCardCommentsViewHandler?([comment1, comment2, comment3, comment4, comment5, comment6, comment7, comment8])
  }
}
