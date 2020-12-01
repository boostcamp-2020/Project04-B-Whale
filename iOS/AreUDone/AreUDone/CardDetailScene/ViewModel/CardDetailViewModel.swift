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
  func bindingCardDetailCommentTableView(handler: @escaping (([CardDetail.Comment]) -> Void))
  func bindingCardDetailNavigationBarTitle(handler: @escaping ((String) -> Void))
  func bindingCardDetailListTitle(handler: @escaping ((String) -> Void))
  func bindingCardDetailBoardTitle(handler: @escaping ((String) -> Void))
  
  func fetchDetailCard()
  func addComment(with comment: String)
}

final class CardDetailViewModel: CardDetailViewModelProtocol {
  
  // MARK:- Property
  
  private var cardService: CardServiceProtocol
  private let id: Int
  
  private var cardDetailContentViewHandler: ((String) -> Void)?
  private var cardDetailDueDateViewHandler: ((String) -> Void)?
  private var cardDetailCommentsViewHandler: (([CardDetail.Comment]) -> Void)?
  private var cardDetailNavigationBarTitleHandler: ((String) -> Void)?
  private var cardDetailListTitleHandler: ((String) -> Void)?
  private var cardDetailBoardTitleHandler: ((String) -> Void)?
  
  
  // MARK:- Initializer
  
  init(id: Int, cardService: CardServiceProtocol) {
    self.id = id
    self.cardService = cardService
  }

  
  // MARK:- Method
  
  func fetchDetailCard() {
    let content = """
                  안녕하세요
                  안녕하세요
                  """
    
    let dueDate = "2020-11-26"
    
    let title = "리스트 끝내기"
    let listTitle = "TODO"
    let boardTitle = "프로젝트1"
    
    let user1 = CardDetail.Comment.User(id: 0, name: "서명렬", profileImageUrl: "")
    let user2 = CardDetail.Comment.User(id: 1, name: "심영민", profileImageUrl: "")
    
    let comment1 = CardDetail.Comment(id: 0, content: "안녕하세요", createdAt: "2020-11-26", user: user1)
    let comment2 = CardDetail.Comment(id: 1, content: "안녕하세요", createdAt: "2020-11-26", user: user2)
    let comment3 = CardDetail.Comment(id: 2, content: "안녕하세요", createdAt: "2020-11-26", user: user2)
    let comment4 = CardDetail.Comment(id: 3, content: "안녕하세요", createdAt: "2020-11-26", user: user2)
    let comment5 = CardDetail.Comment(id: 4, content: "안녕하세요rkskekekekfdsfjdfsjfdsfdsfdsfdsfsdfsdfdsfsdfdsfsdafdsfesdfwefesswfwefdddwefsdfsklfjdsddddfsdfds hjkkkkkk", createdAt: "2020-11-26", user: user2)
    let comment6 = CardDetail.Comment(id: 5, content: "안녕하세요", createdAt: "2020-11-26", user: user2)
    let comment7 = CardDetail.Comment(id: 6, content: "안녕하세요", createdAt: "2020-11-26", user: user2)
    let comment8 = CardDetail.Comment(id: 7, content: "안녕하세요", createdAt: "2020-11-26", user: user2)
    let comment9 = CardDetail.Comment(id: 8, content: "안녕하세요", createdAt: "2020-11-26", user: user2)
    let comment10 = CardDetail.Comment(id: 9, content: "안녕하세요", createdAt: "2020-11-26", user: user2)
    let comment11 = CardDetail.Comment(id: 10, content: "안녕하세요", createdAt: "2020-11-26", user: user2)
    
    cardDetailContentViewHandler?(content)
    cardDetailDueDateViewHandler?(dueDate)
    cardDetailCommentsViewHandler?([comment1, comment2, comment3, comment4, comment5, comment6, comment7, comment8, comment9, comment10, comment11])
    cardDetailNavigationBarTitleHandler?(title)
    cardDetailListTitleHandler?(listTitle)
    cardDetailBoardTitleHandler?(boardTitle)
  }
  
  func addComment(with comment: String) {
    // TODO:- CommentService
  }
}


// MARK:- Extension BindUI

extension CardDetailViewModel {
  
  func bindingCardDetailContentView(handler: @escaping ((String) -> Void)) {
    cardDetailContentViewHandler = handler
  }
  
  func bindingCardDetailDueDateView(handler: @escaping ((String) -> Void)) {
    cardDetailDueDateViewHandler = handler
  }
  
  func bindingCardDetailCommentTableView(handler: @escaping (([CardDetail.Comment]) -> Void)) {
    cardDetailCommentsViewHandler = handler
  }
  
  func bindingCardDetailNavigationBarTitle(handler: @escaping ((String) -> Void)) {
    cardDetailNavigationBarTitleHandler = handler
  }
  
  func bindingCardDetailListTitle(handler: @escaping ((String) -> Void)) {
    cardDetailListTitleHandler = handler
  }
  
  func bindingCardDetailBoardTitle(handler: @escaping ((String) -> Void)) {
    cardDetailBoardTitleHandler = handler
  }
}
