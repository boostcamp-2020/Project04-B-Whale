//
//  BoardLocalDataSource.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/13.
//

import Foundation
import RealmSwift

protocol BoardLocalDataSourceable {

  func save(boards: Boards)
  func save(boardDetail: BoardDetail)
  func save(orderedEndPoint: StoredEndPoint)
  
  func updateBoard(title: String, ofId id: Int)

  func loadBoards() -> Boards?
  func loadBoardDetail(ofId id: Int) -> BoardDetail?
}


final class BoardLocalDataSource: BoardLocalDataSourceable {

  // MARK: - Property
  
  let realm = try! Realm()
  
  
  // MARK: - Method
  
  func save(boards: Boards) {
    realm.writeOnMain(object: boards) { object in
      self.realm.create(Boards.self, value: object, update: .all)
    }
  }
  
  func save(boardDetail: BoardDetail) {
    realm.writeOnMain(object: boardDetail) { object in
      self.realm.create(BoardDetail.self, value: object, update: .all)
    }
  }
  
  func save(orderedEndPoint: StoredEndPoint) {
    realm.writeOnMain(object: orderedEndPoint) { object in
      // 1. EndPoint 저장하고
      self.realm.create(StoredEndPoint.self, value: object)

      // 2. 로컬로 미리 반영
      let boards = self.realm.objects(Boards.self).first ?? Boards()
      let object = Board(value: orderedEndPoint.bodies as Any)
      boards.myBoards.append(object)
    }
  }
  
  func updateBoard(title: String, ofId id: Int) {
    realm.writeOnMain {
      guard let board = self.realm.objects(Board.self).filter("id == %@", id).first else { return }

      board.title = title
    }
  }
  
  func loadBoards() -> Boards? {
    guard let boards = realm.objects(Boards.self).first else { return nil }
    return Boards(value: boards)
  }
  
  func loadBoardDetail(ofId id: Int) -> BoardDetail? {
    guard let boardDetail = realm.objects(BoardDetail.self).filter("id == \(id)").first else { return nil }
    
    return BoardDetail(value: boardDetail)
  }
}
