//
//  ListLocalDataSource.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/13.
//

import Foundation
import RealmSwift

protocol ListLocalDataSourceable {
  func updateList(ofBoardId boardId: Int, title: String?, position: Double?, listId: Int) // 리스트 제목 변경 저장, (미구현)포지션 변경 저장
}


final class ListLocalDataSource: ListLocalDataSourceable {
  
  let realm = try! Realm()
  
  func createList(ofBoardId boardId: Int, list: ListOfBoard) {
    guard let boardDetail =
            realm.objects(BoardDetail.self).filter("id == \(boardId)").first
    else { return }
    
    try! realm.write {
      boardDetail.lists.append(list)
    }
  }
  
  
  func updateList(ofBoardId boardId: Int, title: String?, position: Double?, listId: Int) {
    guard let boardDetail =
            realm.objects(BoardDetail.self).filter("id == \(boardId)").first
    else { return }
    
    if let title = title { // title 바꾼 경우
      for list in boardDetail.lists where list.id == listId {
        try! realm.write {
          list.title = title
        }
        
        break
      }
      
    } else if let _ = position { // position 바꾼 경우
      
    }
  }
}
