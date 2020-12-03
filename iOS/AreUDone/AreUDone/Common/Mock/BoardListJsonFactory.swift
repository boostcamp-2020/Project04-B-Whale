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
                  "title": "보드제목0",
                  "color": "#525252"
              },
              {
                  "id": 1,
                  "title": "보드제목1",
                  "color": "#525252"
              },
              {
                  "id": 2,
                  "title": "보드제목2",
                  "color": "#525252"
              },
              {
                  "id": 3,
                  "title": "보드제목3",
                  "color": "#525252"
              }
          ],
          "invitedBoards": [
              {
                  "id": 4,
                  "title": "보드제목4",
                  "color": "#525252"
              },
              {
                  "id": 5,
                  "title": "보드제목5",
                  "color": "#525252"
              },
              {
                  "id": 6,
                  "title": "보드제목6",
                  "color": "#525252"
              },
              {
                  "id": 7,
                  "title": "보드제목7",
                  "color": "#525252"
              }
          ]
      }
      """.data(using: .utf8)
    default:
      return nil
    }
  }
}
