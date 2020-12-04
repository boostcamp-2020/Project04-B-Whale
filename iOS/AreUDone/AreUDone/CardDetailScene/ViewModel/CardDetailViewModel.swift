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
  func bindingCardDetailCommentCollectionView(handler: @escaping (([CardDetail.Comment]?) -> Void))
  func bindingCardDetailNavigationBarTitle(handler: @escaping ((String) -> Void))
  func bindingCardDetailListTitle(handler: @escaping ((String) -> Void))
  func bindingCardDetailBoardTitle(handler: @escaping ((String) -> Void))
  
  func fetchDetailCard()
  func addComment(with comment: String)
  func updateDueDate(with dueDate: String)
  func updateContent(with content: String)
  func fetchProfileImage(with urlAsString: String, completionHandler: @escaping ((Data) -> Void))
}

final class CardDetailViewModel: CardDetailViewModelProtocol {
  
  // MARK:- Property
  
  private let cardService: CardServiceProtocol
  private let imageService: ImageServiceProtocol
  private let id: Int
  
  private var cardDetailContentViewHandler: ((String?) -> Void)?
  private var cardDetailDueDateViewHandler: ((String) -> Void)?
  private var cardDetailCommentsViewHandler: (([CardDetail.Comment]?) -> Void)?
  private var cardDetailNavigationBarTitleHandler: ((String) -> Void)?
  private var cardDetailListTitleHandler: ((String) -> Void)?
  private var cardDetailBoardTitleHandler: ((String) -> Void)?
  private var updateDueDateHandler: ((String) -> Void)?
  private var updateContentHandler: ((String) -> Void)?
  
  
  // MARK:- Initializer
  
  init(
    id: Int,
    cardService: CardServiceProtocol,
    imageService: ImageServiceProtocol
  ) {
    self.id = id
    self.cardService = cardService
    self.imageService = imageService
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
  
  func updateDueDate(with dueDate: String) {
    cardService.updateCard(
      id: id,
      dueDate: dueDate
    ) { result in
      switch result {
      case .success(()):
        break
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func updateContent(with content: String) {
    cardService.updateCard(
      id: id,
      content: content
    ) { result in
      switch result {
      case .success(()):
        break
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func fetchProfileImage(with urlAsString: String, completionHandler: @escaping ((Data) -> Void)) {
    imageService.fetchImage(with: urlAsString) { result in
      switch result {
      case .success(let data):
        completionHandler(data)
      case .failure(let error):
        print(error)
      }
    }
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
  
  func bindingCardDetailCommentCollectionView(handler: @escaping (([CardDetail.Comment]?) -> Void)) {
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
