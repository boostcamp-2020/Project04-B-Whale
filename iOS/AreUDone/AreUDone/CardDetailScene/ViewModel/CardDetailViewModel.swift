//
//  CardDetailViewModel.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/25.
//

import Foundation

protocol CardDetailViewModelProtocol {
  func bindingCardDetailContentView(handler: @escaping ((String?) -> Void))
  func bindingCardDetailDueDateView(handler: @escaping ((String) -> Void))
  func bindingCardDetailCommentTableView(handler: @escaping (([CardDetail.Comment]?) -> Void))
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
  
  private var cardDetailContentViewHandler: ((String?) -> Void)?
  private var cardDetailDueDateViewHandler: ((String) -> Void)?
  private var cardDetailCommentsViewHandler: (([CardDetail.Comment]?) -> Void)?
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
    cardService.fetchDetailCard(id: id) { result in
      switch result {
      case .success(let detailCard):
        self.cardDetailContentViewHandler?(detailCard.content)
        self.cardDetailDueDateViewHandler?(detailCard.dueDate)
        self.cardDetailCommentsViewHandler?(detailCard.comments)
        self.cardDetailNavigationBarTitleHandler?(detailCard.title)
        self.cardDetailListTitleHandler?(detailCard.list.title)
        self.cardDetailBoardTitleHandler?(detailCard.board.title)
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func addComment(with comment: String) {
    // TODO:- CommentService
  }
}


// MARK:- Extension BindUI

extension CardDetailViewModel {
  
  func bindingCardDetailContentView(handler: @escaping ((String?) -> Void)) {
    cardDetailContentViewHandler = handler
  }
  
  func bindingCardDetailDueDateView(handler: @escaping ((String) -> Void)) {
    cardDetailDueDateViewHandler = handler
  }
  
  func bindingCardDetailCommentTableView(handler: @escaping (([CardDetail.Comment]?) -> Void)) {
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
