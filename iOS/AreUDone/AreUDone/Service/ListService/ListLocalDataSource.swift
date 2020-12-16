//
//  ListLocalDataSource.swift


import Foundation
import RealmSwift

protocol ListLocalDataSourceable {
  
  func save(with boardId: Int, orderedEndPoint: OrderedEndPoint, handler: @escaping (ListOfBoard) -> Void)
}


final class ListLocalDataSource: ListLocalDataSourceable {

  // MARK: - Property
  
  let realm = try! Realm()
  
  
  // MARK: - Method
  
  func save(
    with boardId: Int,
    orderedEndPoint: OrderedEndPoint,
    handler: @escaping (ListOfBoard) -> Void
    ) {
    realm.writeOnMain(object: orderedEndPoint) { object in
      // 1. EndPoint 저장하고
      self.realm.create(OrderedEndPoint.self, value: object)

      // 2. 로컬로 미리 반영
      if let boardDetail =
          self.realm.objects(BoardDetail.self)
          .filter("id == \(boardId)").first
      {
        let object = ListOfBoard(value: orderedEndPoint.bodies as Any)
        boardDetail.lists.append(object)
        
        // 3. unmanaged object 로 반환
        handler(ListOfBoard(value: object))
      }
    }
  }
}
