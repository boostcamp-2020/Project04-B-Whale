//
//  MemberUpdateViewModel.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/07.
//

import Foundation

protocol MemberUpdateViewModelProtocol {
  
  func fetchMemberData(completionHandler: @escaping (([User], [User]?) -> Void))
  func fetchProfileImage(with urlAsString: String, completionHandler: @escaping ((Data) -> Void))
  func updateCardMember(with member: [User], completionHandler: @escaping () -> Void)
}

final class MemberUpdateViewModel: MemberUpdateViewModelProtocol {
  
  // MARK:- Property
  
  private let cardId: Int
  private let boardId: Int
  private let cardMember: [User]?
  private let boardService: BoardServiceProtocol
  private let imageService: ImageServiceProtocol
  private let cardService: CardServiceProtocol
  
  private let cache: NSCache<NSString, NSData> = NSCache()
  
  
  // MARK:- Initializer
  
  init(
    cardId: Int,
    boardId: Int,
    cardMember: [User]?,
    boardService: BoardServiceProtocol,
    imageService: ImageServiceProtocol,
    cardService: CardServiceProtocol
  ) {
    self.cardId = cardId
    self.boardId = boardId
    self.cardMember = cardMember
    self.boardService = boardService
    self.imageService = imageService
    self.cardService = cardService
  }
  
  func fetchMemberData(completionHandler: @escaping (([User], [User]?) -> Void)) {
    boardService.fetchBoardDetail(with: boardId) { result in
      switch result {
      case .success(let boardDetail):
        DispatchQueue.main.async {
          var boardMember = boardDetail.fetchInvitedUsers()
          boardMember.append(boardDetail.creator!)
          
          guard let cardMember = self.cardMember else {
            completionHandler(boardMember, nil)
            return
          }
          
          let notCardMember = Set(boardMember).subtracting(cardMember).sorted { $0.id < $1.id }
          completionHandler(notCardMember, cardMember)
        }
        
        
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
          
        case .failure(let error):
          print(error)
        }
      }
    }
  }
  
  func updateCardMember(with members: [User], completionHandler: @escaping () -> Void) {
    var userIds = [Int]()
    members.forEach { member in
      userIds.append(member.id)
    }
    cardService.updateCardMember(id: cardId, userIds: userIds) { result in
      switch result {
      case .success(()):
        completionHandler()
        
      case .failure(let error):
        print(error)
      }
    }
  }
}
