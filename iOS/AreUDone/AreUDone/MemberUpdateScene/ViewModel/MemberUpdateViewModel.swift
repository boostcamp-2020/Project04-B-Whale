//
//  MemberUpdateViewModel.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/07.
//

import Foundation

protocol MemberUpdateViewModelProtocol {
  
  func fetchMemberData(completionHandler: @escaping (([InvitedUser], [InvitedUser]?) -> Void))
}

final class MemberUpdateViewModel: MemberUpdateViewModelProtocol {
  
  // MARK:- Property
  
  private let boardId: Int
  private let cardMember: [InvitedUser]?
  private let boardService: BoardServiceProtocol
  
  // MARK:- Initializer
  
  init(boardId: Int, cardMember: [InvitedUser]?, boardService: BoardServiceProtocol) {
    self.boardId = boardId
    self.cardMember = cardMember
    self.boardService = boardService
  }
  
  func fetchMemberData(completionHandler: @escaping (([InvitedUser], [InvitedUser]?) -> Void)) {
    boardService.fetchBoardDetail(with: boardId) { result in
      switch result {
      case .success(let boardDetail):
        let boardMember = boardDetail.invitedUsers
        guard let cardMember = self.cardMember else {
          completionHandler(boardMember, nil)
          return
        }

        let notCardMember = Set(boardMember).subtracting(cardMember).sorted { $0.id < $1.id }
        completionHandler(notCardMember, cardMember)
      case .failure(let error):
        print(error)
      }
    }
  }
}
