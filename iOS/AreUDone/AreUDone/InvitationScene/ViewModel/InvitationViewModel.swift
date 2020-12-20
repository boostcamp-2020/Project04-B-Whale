//
//  InvitationViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/05.
//

import Foundation

protocol InvitationViewModelProtocol {
  
  func bindingUpdateInvitationTableView(handler: @escaping () -> Void) 
  
  func numberOfUsers() -> Int
  func fetchUserInfo(at index: Int, handler: @escaping ((User, Bool), Data) -> Void)
  
  func searchUser(of userName: String)
  func inviteUserToBoard(of index: Int)
}

final class InvitationViewModel: InvitationViewModelProtocol {
  
  // MARK: - Property
  
  private let userService: UserServiceProtocol
  private let boardService: BoardServiceProtocol
  private let imageService: ImageServiceProtocol
  private let boardId: Int
  private var members: [User]
  
  private var updateInvitationTableViewHandler: (() -> Void)?
  
  private var users: [(info: User, isInvited: Bool)]? {
    didSet {
      updateInvitationTableViewHandler?()
    }
  }
  
  private let cache: NSCache<NSString, NSData> = NSCache()
  
  
  // MARK: - Initializer
  
  init(
    userService: UserServiceProtocol,
    boardService: BoardServiceProtocol,
    imageService: ImageServiceProtocol,
    boardId: Int,
    members: [User]) {
    self.userService = userService
    self.boardService = boardService
    self.imageService = imageService
    self.boardId = boardId
    self.members = members
  }
  
  func numberOfUsers() -> Int {
    return users?.count ?? 0
  }
  
  func fetchUserInfo(at index: Int, handler: @escaping ((User, Bool), Data) -> Void) {
    guard let user = users?[index] else { return }
    
    fetchProfileImage(with: user.info.profileImageUrl, userName: user.info.name) { data in
      handler(user, data)
    }
  }
  
  func searchUser(of searchKeyword: String) {
    let trimmedSearchKeyword = searchKeyword.trimmed
    guard !trimmedSearchKeyword.isEmpty else {
      users = .none
      return
    }
    
    var keyword = searchKeyword
    if trimmedSearchKeyword == "@developer" {
      keyword = ""
    }
    
    userService.fetchUserInfo(userName: keyword) { result in
      switch result {
      case .success(let users):
        let uninvitedUsersSet = Set(users).subtracting(self.members)
        let unvitedUsers = Array(uninvitedUsersSet).sorted { $0.name < $1.name }.map { ($0, false) }
        
        let invitedUsers = Set(self.members).intersection(users).sorted { $0.name < $1.name }.map { ($0, true) }
        
        self.users = invitedUsers + unvitedUsers
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func inviteUserToBoard(of index: Int) {
    guard let userId = users?[index].info.id else { return }
    
    boardService.inviteUserToBoard(withBoardId: boardId, andUserId: userId) { result in
      switch result {
      case .success(()):
        self.users?[index].isInvited = true
        if let user = self.users?[index].info {
          self.members.append(user)
        }

      case .failure(let error):
        print(error)
      }
    }
  }
}


// MARK: - Extension

private extension InvitationViewModel {
  
  func fetchProfileImage(with urlAsString: String, userName: String, handler: @escaping ((Data) -> Void)) {
    if let cachedData = cache.object(forKey: urlAsString as NSString) {
      handler(cachedData as Data)
      
    } else {
      imageService.fetchImage(with: urlAsString, imageName: userName) { result in
        switch result {
        case .success(let data):
          self.cache.setObject(data as NSData, forKey: urlAsString as NSString)
          handler(data)
          
        case .failure(let error):
          print(error)
        }
      }
    }
  }
}


// MARK: - Extension BindUI

extension InvitationViewModel {
  
  func bindingUpdateInvitationTableView(handler: @escaping () -> Void) {
    updateInvitationTableViewHandler = handler
  }
}
