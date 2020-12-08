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
  func bindingCommentViewProfileImage(handler: @escaping ((Data) -> Void))
  func bindingCardDetailMemberView(handler: @escaping (([User]?) -> Void))
  
  func fetchDetailCard()
  func addComment(with comment: String)
  func updateDueDate(with dueDate: String)
  func updateContent(with content: String)
  func prepareUpdateMember(handler: (Int, Int, [User]?) -> Void)
  func fetchProfileImage(with urlAsString: String, completionHandler: @escaping ((Data) -> Void))
}

final class CardDetailViewModel: CardDetailViewModelProtocol {
  
  // MARK:- Property
  
  private let cardService: CardServiceProtocol
  private let imageService: ImageServiceProtocol
  private let userService: UserServiceProtocol
  private let id: Int
  
  private var cardDetailContentViewHandler: ((String?) -> Void)?
  private var cardDetailDueDateViewHandler: ((String) -> Void)?
  private var cardDetailCommentsViewHandler: (([CardDetail.Comment]?) -> Void)?
  private var cardDetailNavigationBarTitleHandler: ((String) -> Void)?
  private var cardDetailListTitleHandler: ((String) -> Void)?
  private var cardDetailBoardTitleHandler: ((String) -> Void)?
  private var updateDueDateHandler: ((String) -> Void)?
  private var updateContentHandler: ((String) -> Void)?
  private var commentViewProfileImageHandler: ((Data) -> Void)?
  private var cardDetailMemberViewHandler: (([User]?) -> Void)?
  
  private let cache: NSCache<NSString, NSData> = NSCache()
  
  private var boardId: Int?
  private var cardMembers: [User]?
  
  // MARK:- Initializer
  
  init(
    id: Int,
    cardService: CardServiceProtocol,
    imageService: ImageServiceProtocol,
    userService: UserServiceProtocol
  ) {
    self.id = id
    self.cardService = cardService
    self.imageService = imageService
    self.userService = userService
  }

  
  // MARK:- Method
  
  func fetchDetailCard() {
    cardService.fetchDetailCard(id: id) { [weak self] result in
      switch result {
      case .success(let detailCard):
        self?.boardId = detailCard.board.id
        self?.cardMembers = detailCard.members
        
        self?.cardDetailContentViewHandler?(detailCard.content)
        self?.cardDetailDueDateViewHandler?(detailCard.dueDate)
        self?.cardDetailCommentsViewHandler?(detailCard.comments)
        self?.cardDetailNavigationBarTitleHandler?(detailCard.title)
        self?.cardDetailListTitleHandler?(detailCard.list.title)
        self?.cardDetailBoardTitleHandler?(detailCard.board.title)
        self?.cardDetailMemberViewHandler?(detailCard.members)
        self?.fetchUserData()
        
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
    if let cachedData = cache.object(forKey: urlAsString as NSString) {
      completionHandler(cachedData as Data)
      
    } else {
      imageService.fetchImage(with: urlAsString) { result in
        switch result {
        case .success(let data):
          completionHandler(data)
          self.cache.setObject(data as NSData, forKey: urlAsString as NSString)
        case .failure(let error):
          print(error)
        }
      }
    }
  }
  
  func prepareUpdateMember(handler: (Int, Int, [User]?) -> Void) {
    guard let boardId = boardId else { return }
    handler(id, boardId, cardMembers)
  }
  
  private func fetchUserData() {
    userService.requestMe { [weak self] result in
      switch result {
      case .success(let user):
        self?.fetchProfileImage(with: user.profileImageUrl) { data in
          self?.commentViewProfileImageHandler?(data)
        }
        
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
  
  func bindingCommentViewProfileImage(handler: @escaping ((Data) -> Void)) {
    commentViewProfileImageHandler = handler
  }
  
  func bindingCardDetailMemberView(handler: @escaping (([User]?) -> Void)) {
    cardDetailMemberViewHandler = handler
  }
}
