//
//  SideBarViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/02.
//

import Foundation

protocol SideBarViewModelProtocol {
  
  func bindingUpdateMembersInCollectionView(handler: @escaping () -> Void)
  func bindingUpdateActivitiesInCollectionView(handler: @escaping () -> Void)
  
  func updateMembersInCollectionView()
  func updateActivitiesInCollectionView()
  
  
  func numberOfMembers() -> Int
  func numberOfActivities() -> Int
  func fetchMember(at index: Int) -> InvitedUser?
  func fetchActivity(at index: Int) -> Activity?
}

final class SideBarViewModel: SideBarViewModelProtocol {
  
  // MARK: - Property
  
  private let boardService: BoardServiceProtocol
  private let activityService: ActivityServiceProtocol
  private let boardId: Int
  
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
  
  
  // MARK: - Initializer
  
  init(
    boardService: BoardServiceProtocol,
    activityService: ActivityServiceProtocol,
    boardId: Int
  ) {
    self.boardService = boardService
    self.activityService = activityService
    self.boardId = boardId
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
  
  func fetchMember(at index: Int) -> InvitedUser? {
    return boardMembers?[index]
  }
  
  func fetchActivity(at index: Int) -> Activity? {
    return boardActivities?[index]
  }
  
  func numberOfMembers() -> Int {
    return boardMembers?.count ?? 0
  }
  
  func numberOfActivities() -> Int {
    return boardActivities?.count ?? 0
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





