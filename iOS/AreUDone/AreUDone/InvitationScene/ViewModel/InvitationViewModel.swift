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
  func fetchUserInfo(at index: Int, handler: @escaping (User, Data) -> Void)
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
  
  private var updateInvitationTableViewHandler: (() -> Void)?

  private var users: [User]? {
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
    boardId: Int) {
    self.userService = userService
    self.boardService = boardService
    self.imageService = imageService
    self.boardId = boardId
  }
  
  func numberOfUsers() -> Int {
    return users?.count ?? 0
  }
  
  func fetchUserInfo(at index: Int, handler: @escaping (User, Data) -> Void) {
    guard let user = users?[index] else { return }
    
    fetchProfileImage(with: user.profileImageUrl, userName: user.name) { data in
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
        self.users = users
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func inviteUserToBoard(of index: Int) {
    guard let userId = users?[index].id else { return }
    
    boardService.requestInvitation(withBoardId: boardId, andUserId: userId) { result in
      switch result {
      case .success(()):
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
