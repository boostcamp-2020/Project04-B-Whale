//
//  BoardJsonFactory.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import Foundation
import NetworkFramework

struct BoardListTrueJsonFactory: JsonFactory {
  
  func loadJson(endPoint: EndPointable) -> Data? {
    switch endPoint {
    case BoardEndPoint.fetchAllBoards:
      return """
      {
          "myBoards": [
              {
                  "id": 0,
                  "title": "보드제목0"
              },
              {
                  "id": 1,
                  "title": "보드제목1"
              },
              {
                  "id": 2,
                  "title": "보드제목2"
              },
              {
                  "id": 3,
                  "title": "보드제목3"
              }
          ],
          "invitedBoards": [
              {
                  "id": 4,
                  "title": "보드제목4"
              },
              {
                  "id": 5,
                  "title": "보드제목5"
              },
              {
                  "id": 6,
                  "title": "보드제목6"
              },
              {
                  "id": 7,
                  "title": "보드제목7"
              }
          ]
      }
      """.data(using: .utf8)
    default:
      return nil
    }
  }
}
