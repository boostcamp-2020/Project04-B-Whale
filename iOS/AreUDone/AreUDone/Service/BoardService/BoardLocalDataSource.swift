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
  
  func loadBoards() -> Boards
  func loadBoardDetail(ofId id: Int) -> BoardDetail?
}

// 해야할 것. 백그라운드에서 해도 되는거같은데.. 같은 스레드이기만 하면 되는건지?

final class BoardLocalDataSource: BoardLocalDataSourceable {
  
  let realm = try! Realm()
  
  func save(boards: Boards) {

    try! realm.write {
      realm.add(boards)
    }
  }
  
  // 그냥 Object 를 넘겨도 되지 않을까 싶은데..
  func save(boardDetail: BoardDetail) {
    try! realm.write {
      realm.add(boardDetail, update: .all)
    }
  }
  
  func loadBoards() -> Boards {
    let boards = realm.objects(Boards.self).first

    return boards ?? Boards()
  }
  
  func loadBoardDetail(ofId id: Int) -> BoardDetail? {
//    let boardDetail = realm.objects(BoardDetail.self)
    
    let boardDetail = realm.objects(BoardDetail.self).filter("id == \(id)").first

    return boardDetail
  }
}



//    let objects = List<Board>()
//    let objects2 = List<Board>()
//
//    zip(boards.myBoards, boards.invitedBoards).forEach {
//      objects.append($0.0)
//      objects2.append($0.1)
//    }
//
//    let realmBoards = RealmBoards(value: ["myBoards": objects, "invitedBoards": objects2])
//
    

