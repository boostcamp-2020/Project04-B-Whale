//
//  InvitationViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/05.
//

import Foundation

protocol InvitationViewModelProtocol {
  
  func bindingUpdateInvitationTableView(handler: @escaping () -> Void) // reload
  
  func numberOfUsers() -> Int
  func fetchUserInfo(at index: Int, handler: @escaping ((User, Bool), Data) -> Void)
  func fetchProfileImage(with urlAsString: String, userName: String, handler: @escaping ((Data) -> Void))
  
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
  
  private var users: [(User, Bool)]? {
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
    
    fetchProfileImage(with: user.0.profileImageUrl, userName: user.0.name) { data in
      handler(user, data)
    }
  }
  
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
  
  func searchUser(of userName: String) {
    userService.fetchUserInfo(userName: userName) { result in
      switch result {
      case .success(let users):
        
        
        // set 계산
        let uninvitedUsersSet = Set(users).subtracting(Set(self.members))
        let unvitedUsers = Array(uninvitedUsersSet).sorted { $0.name < $1.name }.map { ($0, false) }
        let invitedUsers = self.members.map { ($0, true) }
        
        self.users = invitedUsers + unvitedUsers
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func inviteUserToBoard(of index: Int) {
    guard let userId = users?[index].0.id else { return }
    
    boardService.requestInvitation(withBoardId: boardId, andUserId: userId) { result in
      switch result {
      case .success(()):
        self.users?[index].1 = true
        
        break
        
      case .failure(let error):
        print(error)
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
