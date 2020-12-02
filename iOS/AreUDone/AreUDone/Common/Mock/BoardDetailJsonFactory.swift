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
              },
              {
                  "id": 1,
                  "title": "리스트 제목2",
                  "position": 1,
                  "cards": [
                      {
                          "id": 0,
                          "title": "카드 제목2",
                          "position": 0,
                          "commentCount": 5,
                          "dueDate": "2020-12-02"
                      },
                      {
                          "id": 0,
                          "title": "카드 제목3",
                          "position": 0,
                          "commentCount": 5,
                          "dueDate": "2020-12-02"
                      },
                      {
                          "id": 0,
                          "title": "카드 제목4",
                          "position": 0,
                          "commentCount": 5,
                          "dueDate": "2020-12-02"
                      },
                      {
                          "id": 0,
                          "title": "카드 제목5",
                          "position": 0,
                          "commentCount": 5,
                          "dueDate": "2020-12-02"
                      },
                      {
                          "id": 0,
                          "title": "카드 제목6",
                          "position": 0,
                          "commentCount": 5,
                          "dueDate": "2020-12-02"
                      },
                      {
                          "id": 0,
                          "title": "카드 제목7",
                          "position": 0,
                          "commentCount": 5,
                          "dueDate": "2020-12-02"
                      },
                      {
                          "id": 0,
                          "title": "카드 제목8",
                          "position": 0,
                          "commentCount": 5,
                          "dueDate": "2020-12-02"
                      },
                      {
                          "id": 0,
                          "title": "카드 제목9",
                          "position": 0,
                          "commentCount": 5,
                          "dueDate": "2020-12-02"
                      },
                      {
                          "id": 0,
                          "title": "카드 제목10",
                          "position": 0,
                          "commentCount": 5,
                          "dueDate": "2020-12-02"
                      },
                      {
                          "id": 0,
                          "title": "카드 제목11",
                          "position": 0,
                          "commentCount": 5,
                          "dueDate": "2020-12-02"
                      },
                      {
                          "id": 0,
                          "title": "카드 제목12",
                          "position": 0,
                          "commentCount": 5,
                          "dueDate": "2020-12-02"
                      },
                      {
                          "id": 0,
                          "title": "카드 제목13",
                          "position": 0,
                          "commentCount": 5,
                          "dueDate": "2020-12-02"
                      },
                      {
                          "id": 0,
                          "title": "카드 제목14",
                          "position": 0,
                          "commentCount": 5,
                          "dueDate": "2020-12-02"
                      },
                      {
                          "id": 0,
                          "title": "카드 제목15",
                          "position": 0,
                          "commentCount": 5,
                          "dueDate": "2020-12-02"
                      },
                      {
                          "id": 0,
                          "title": "카드 제목16",
                          "position": 0,
                          "commentCount": 5,
                          "dueDate": "2020-12-02"
                      },
                      {
                          "id": 0,
                          "title": "카드 제목17",
                          "position": 0,
                          "commentCount": 5,
                          "dueDate": "2020-12-02"
                      },
                      {
                          "id": 0,
                          "title": "카드 제목18",
                          "position": 0,
                          "commentCount": 5,
                          "dueDate": "2020-12-02"
                      },
                      {
                          "id": 0,
                          "title": "카드 제목19",
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



