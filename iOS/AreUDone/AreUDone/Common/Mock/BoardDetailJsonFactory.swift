//
//  BoardDetailJsonFactory.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/02.
//

import Foundation
import NetworkFramework

struct BoardDetailTrueJsonFactory: JsonFactory {
  
  func loadJson(endPoint: EndPointable) -> Data? {
    switch endPoint {
    case BoardEndPoint.fetchBoardDetail:
      return """
      {
          "id": 0,
          "creator": {
              "id": 0,
              "name": "심영민"
          },
          "title": "보드제목",
          "color": "#525252",
          "invitedUsers": [
              {
                  "id": 1,
                  "name": "서명렬",
                  "profileImageUrl": "www.naver.com"
              }
          ],
          "lists": [
              {
                  "id": 0,
                  "title": "리스트 제목",
                  "position": 0,
                  "cards": [
                      {
                          "id": 0,
                          "title": "카드 제목",
                          "position": 0,
                          "commentCount": 5,
                          "dueDate": "2020-12-02"
                      }
                  ]
              }
          ]
      }

      """.data(using: .utf8)
    default:
      return nil
    }
  }
}



