//
//  SideBarViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/02.
//

import Foundation
import NetworkFramework

protocol SideBarViewModelProtocol {
  
  func bindingUpdateSideBarCollectionView(handler: @escaping () -> Void)
//  func bindingUpdateActivitiesInCollectionView(handler: @escaping () -> Void)
  
  func updateCollectionView()
//  func updateMembersInCollectionView()
//  func updateActivitiesInCollectionView()
  
  func numberOfMembers() -> Int
  func numberOfActivities() -> Int
  func fetchMember(at index: Int) -> User?
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
  
  private var updateSideBarCollectionViewHandler: (() -> Void)?
//  private var updateActivitiesInCollectionViewHandler: (() -> Void)?
  
  private var boardMembers: [User]? {
    didSet {
//      updateSideBarCollectionViewHandler?()
    }
  }
  private var boardActivities: [Activity]? {
    didSet {
      // TODO: boardActivity 는 viewModel 나눠야하나?
//      updateActivitiesInCollectionViewHandler?()
    }
  }
  
  private let cache: NSCache<NSString, NSData> = NSCache()
  let group = DispatchGroup()

  
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
  
  func updateCollectionView() {
    
    fetchMembers()
    fetchActivities()
    
    group.notify(queue: .main) {
      self.updateSideBarCollectionViewHandler?()
    }
  }
  
  private func fetchMembers() {
    group.enter()

    boardService.fetchBoardDetail(with: boardId) { result in
      switch result {
      case .success(let boardDetail):
        var invitedUsers = boardDetail.invitedUsers
        invitedUsers.insert(boardDetail.creator, at: 0)
        
        self.boardMembers = invitedUsers
        
      case .failure(let error):
        print(error)
      }
      self.group.leave()
    }
  }
  
  private func fetchActivities() {
    group.enter()

    activityService.fetchActivities(withBoardId: boardId) { result in
      switch result {
      case .success(let activities):
        self.boardActivities = activities.activities // TODO: 추후 네이밍 바꾸기(activities 중복)
      case .failure(let error):
        print(error)
      }
      self.group.leave()
    }
  }
  
  func numberOfMembers() -> Int {
    return boardMembers?.count ?? 0
  }
  
  func numberOfActivities() -> Int {
    return boardActivities?.count ?? 0
  }
  
  func fetchMember(at index: Int) -> User? {
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
  
  func bindingUpdateSideBarCollectionView(handler: @escaping () -> Void) {
    updateSideBarCollectionViewHandler = handler
  }
  
//  func bindingUpdateActivitiesInCollectionView(handler: @escaping () -> Void) {
//    updateActivitiesInCollectionViewHandler = handler
//  }
}





