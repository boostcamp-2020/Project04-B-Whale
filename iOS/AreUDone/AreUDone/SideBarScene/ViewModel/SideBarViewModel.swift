//
//  SideBarViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/02.
//

import Foundation
import NetworkFramework

protocol SideBarViewModelProtocol {
  
  func bindingUpdateMembersInCollectionView(handler: @escaping () -> Void)
  func bindingUpdateActivitiesInCollectionView(handler: @escaping () -> Void)
  
  func updateMembersInCollectionView()
  func updateActivitiesInCollectionView()
  
  func numberOfMembers() -> Int
  func numberOfActivities() -> Int
  func fetchMember(at index: Int) -> InvitedUser?
  func fetchActivity(at index: Int) -> Activity?
  func fetchSectionHeader(at index: Int) -> (image: String, title: String)
  func fetchProfileImage(with url: String, handler: @escaping (Data) -> Void)
}

final class SideBarViewModel: SideBarViewModelProtocol {
  
  // MARK: - Property
  
  private let boardService: BoardServiceProtocol
  private let activityService: ActivityServiceProtocol
  private let imageService: ImageServiceProtocol
  private let boardId: Int
  private let sideBarHeaderContentsFactory: SideBarHeaderContentsFactoryProtocol
  
  private var updateMembersInCollectionViewHandler: (() -> Void)?
  private var updateActivitiesInCollectionViewHandler: (() -> Void)?
  
  private var boardMembers: [InvitedUser]? {
    didSet {
      updateMembersInCollectionViewHandler?()
    }
  }
  private var boardActivities: [Activity]? {
    didSet {
      updateActivitiesInCollectionViewHandler?()
    }
  }
  
  private let cache: NSCache<NSString, NSData> = NSCache()

  
  // MARK: - Initializer
  
  init(
    boardService: BoardServiceProtocol,
    activityService: ActivityServiceProtocol,
    imageService: ImageServiceProtocol,
    boardId: Int,
    sideBarHeaderContentsFactory: SideBarHeaderContentsFactoryProtocol
  ) {
    self.boardService = boardService
    self.activityService = activityService
    self.imageService = imageService
    self.boardId = boardId
    self.sideBarHeaderContentsFactory = sideBarHeaderContentsFactory
  }
  
  
  // MARK: - Method
  
  func updateMembersInCollectionView() {
    boardService.fetchBoardDetail(withBoardId: boardId) { result in
      switch result {
      case .success(let boardDetail):
        self.boardMembers = boardDetail.invitedUsers
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func updateActivitiesInCollectionView() {
    activityService.fetchActivities(withBoardId: boardId) { result in
      switch result {
      case .success(let activities):
        self.boardActivities = activities.activities // TODO: 추후 네이밍 바꾸기(activities 중복)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func numberOfMembers() -> Int {
    return boardMembers?.count ?? 0
  }
  
  func numberOfActivities() -> Int {
    return boardActivities?.count ?? 0
  }
  
  func fetchMember(at index: Int) -> InvitedUser? {
    
    return boardMembers?[index]
  }
  
  func fetchActivity(at index: Int) -> Activity? {
    return boardActivities?[index]
  }
  
  func fetchSectionHeader(at index: Int) -> (image: String, title: String) {
    return sideBarHeaderContentsFactory.load(order: index)
  }
  
  func fetchProfileImage(with urlAsString: String, handler: @escaping ((Data) -> Void)) {
    if let cachedData = cache.object(forKey: urlAsString as NSString) {
      handler(cachedData as Data)
      
    } else {
      imageService.fetchImage(with: urlAsString) { result in
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


// MARK: - Extension bindUI

extension SideBarViewModel {
  
  func bindingUpdateMembersInCollectionView(handler: @escaping () -> Void) {
    updateMembersInCollectionViewHandler = handler
  }
  
  func bindingUpdateActivitiesInCollectionView(handler: @escaping () -> Void) {
    updateActivitiesInCollectionViewHandler = handler
  }
}





