//
//  BoardLocalDataSource.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/13.
//

import Foundation
import RealmSwift

protocol BoardLocalDataSourceable {
  func save(boards: Boards) // 보드 목록
  func save(boardDetail: BoardDetail) // 상세화면 저장
  func updateBoard(title: String, ofId id: Int) // 보드 제목 변경 저장

  func loadBoards() -> Boards?
  func loadBoardDetail(ofId id: Int) -> BoardDetail?
}


final class BoardLocalDataSource: BoardLocalDataSourceable {

  let realm = try! Realm()
  
  
  func save(boards: Boards) {
    realm.writeOnMain(object: boards) { object in
      self.realm.add(object)
    }
  }
  
  func save(boardDetail: BoardDetail) {
    realm.writeOnMain(object: boardDetail) { object in
      self.realm.add(object, update: .all)
    }
  }
  
  func updateBoard(title: String, ofId id: Int) {
    guard let boardDetail =
            realm.objects(BoardDetail.self).filter("id == \(id)").first
    else { return }
    
    realm.writeOnMain(object: boardDetail) { object in
      boardDetail.title = title
      self.realm.add(object)
    }
  }
  
  func loadBoards() -> Boards? {
    let boards = realm.objects(Boards.self).first
    return boards
  }
  
  func loadBoardDetail(ofId id: Int) -> BoardDetail? {
    let boardDetail = realm.objects(BoardDetail.self).filter("id == \(id)").first
    return boardDetail
  }
}
