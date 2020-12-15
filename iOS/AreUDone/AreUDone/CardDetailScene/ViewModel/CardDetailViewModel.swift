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
  func bindingCardDetailCommentCollectionView(handler: @escaping (([CardDetailComment]?) -> Void))
  func bindingCardDetailNavigationBarTitle(handler: @escaping ((String) -> Void))
  func bindingCardDetailListTitle(handler: @escaping ((String) -> Void))
  func bindingCardDetailBoardTitle(handler: @escaping ((String) -> Void))
  func bindingCommentViewProfileImage(handler: @escaping ((Data) -> Void))
  func bindingCardDetailMemberView(handler: @escaping (([User]?) -> Void))
  func bindingUpdateDueDateView(handler: @escaping ((String) -> Void))
  func bindingUpdateContentView(handler: @escaping ((String) -> Void))
  func bindingPrepareForUpdateMemberView(handler: @escaping ((Int, Int, [User]?) -> Void))
  
  func fetchDetailCard()
  func addComment(with comment: String, completionHandler: @escaping (() -> Void))
  func updateDueDate(with dueDate: String)
  func updateContent(with content: String)
  func prepareUpdateMemberView()
  func prepareUpdateCell(handler: (Int) -> Void)
  func deleteComment(with commentId: Int, completionHandler: @escaping () -> Void)
  func fetchProfileImage(with urlAsString: String, userName: String, completionHandler: @escaping ((Data) -> Void))
}

final class CardDetailViewModel: CardDetailViewModelProtocol {
  
  // MARK:- Property
  
  private let cardService: CardServiceProtocol
  private let imageService: ImageServiceProtocol
  private let userService: UserServiceProtocol
  private let commentService: CommentServiceProtocol
  private let id: Int
  
  private var cardDetailContentViewHandler: ((String?) -> Void)?
  private var cardDetailDueDateViewHandler: ((String) -> Void)?
  private var cardDetailCommentsViewHandler: (([CardDetailComment]?) -> Void)?
  private var cardDetailNavigationBarTitleHandler: ((String) -> Void)?
  private var cardDetailListTitleHandler: ((String) -> Void)?
  private var cardDetailBoardTitleHandler: ((String) -> Void)?
  private var updateDueDateHandler: ((String) -> Void)?
  private var updateContentHandler: ((String) -> Void)?
  private var commentViewProfileImageHandler: ((Data) -> Void)?
  private var cardDetailMemberViewHandler: (([User]?) -> Void)?
  private var prepareForUpdateMemberViewHandler: ((Int, Int, [User]?) -> Void)?
  
  private let cache: NSCache<NSString, NSData> = NSCache()
  
  private var boardId: Int?
  private var cardMembers: [User]?
  
  // MARK:- Initializer
  
  init(
    id: Int,
    cardService: CardServiceProtocol,
    imageService: ImageServiceProtocol,
    userService: UserServiceProtocol,
    commentService: CommentServiceProtocol
  ) {
    self.id = id
    self.cardService = cardService
    self.imageService = imageService
    self.userService = userService
    self.commentService = commentService
  }
  
  
  // MARK:- Method
  
  func fetchDetailCard() {
    cardService.fetchDetailCard(id: id) { [weak self] result in
      switch result {
      case .success(let detailCard):
        self?.boardId = detailCard.board!.id
        self?.cardMembers = detailCard.fetchMembers()
        
        self?.cardDetailContentViewHandler?(detailCard.content)
        self?.cardDetailDueDateViewHandler?(detailCard.dueDate)
        self?.cardDetailCommentsViewHandler?(detailCard.fetchComment())
        self?.cardDetailNavigationBarTitleHandler?(detailCard.title)
        self?.cardDetailListTitleHandler?(detailCard.list!.title)
        self?.cardDetailBoardTitleHandler?(detailCard.board!.title)
        self?.cardDetailMemberViewHandler?(detailCard.fetchMembers())
        self?.fetchUserData()
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func addComment(with comment: String, completionHandler: @escaping (() -> Void)) {
    commentService.createComment(with: id, content: comment) { result in
      switch result {
      case .success(()):
        completionHandler()
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func updateDueDate(with dueDate: String) {
    cardService.updateCard(id: id, dueDate: dueDate) { [weak self] result in
      switch result {
      case .success(()):
        self?.updateDueDateHandler?(dueDate)
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func updateContent(with content: String) {
    cardService.updateCard(id: id, content: content) { [weak self] result in
      switch result {
      case .success(()):
        self?.updateContentHandler?(content)
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func fetchProfileImage(with urlAsString: String, userName: String, completionHandler: @escaping ((Data) -> Void)) {
    if let cachedData = cache.object(forKey: urlAsString as NSString) {
      completionHandler(cachedData as Data)
      
    } else {
      imageService.fetchImage(with: urlAsString, imageName: userName) { result in
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
  
  func prepareUpdateCell(handler: (Int) -> Void) {
    guard let userId = Int(UserInfo.shared.userId) else { return }
    handler(userId)
  }
  
  func prepareUpdateMemberView() {
    guard let boardId = boardId else { return }
    prepareForUpdateMemberViewHandler?(id, boardId, cardMembers)
  }
  
  func deleteComment(with commentId: Int, completionHandler: @escaping () -> Void) {
    commentService.deleteComment(with: commentId) { result in
      switch result {
      case .success(()):
        completionHandler()
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  private func fetchUserData() {
    userService.requestMe { [weak self] result in
      switch result {
      case .success(let user):
        if let cachedData = self?.cache.object(forKey: user.profileImageUrl as NSString) {
          self?.commentViewProfileImageHandler?(cachedData as Data)
        } else {
          self?.fetchProfileImage(with: user.profileImageUrl, userName: user.name) { data in
            self?.commentViewProfileImageHandler?(data)
          }
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
  
  func bindingCardDetailCommentCollectionView(handler: @escaping (([CardDetailComment]?) -> Void)) {
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
  
  func bindingUpdateDueDateView(handler: @escaping ((String) -> Void)) {
    updateDueDateHandler = handler
  }
  
  func bindingUpdateContentView(handler: @escaping ((String) -> Void)) {
    updateContentHandler = handler
  }
  
  func bindingPrepareForUpdateMemberView(handler: @escaping ((Int, Int, [User]?) -> Void)) {
    prepareForUpdateMemberViewHandler = handler
  }
}
