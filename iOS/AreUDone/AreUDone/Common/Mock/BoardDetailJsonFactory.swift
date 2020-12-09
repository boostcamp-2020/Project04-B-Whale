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
          "id": 1,
          "creator": {
              "id": 2,
              "name": "심영민",
              "profileImageUrl": "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/436/8142f53e51d2ec31bc0fa4bec241a919_crop.jpeg"
          },
          "title": "보드제목",
          "color": "#b1cf99",
          "invitedUsers": [
              {
                  "id": 1,
                  "name": "서명렬",
                  "profileImageUrl": "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/436/8142f53e51d2ec31bc0fa4bec241a919_crop.jpeg"
              },
              {
                  "id": 2,
                  "name": "박수연",
                  "profileImageUrl": "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/436/8142f53e51d2ec31bc0fa4bec241a919_crop.jpeg"
              },
              {
                  "id": 3,
                  "name": "이건홍",
                  "profileImageUrl": "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/436/8142f53e51d2ec31bc0fa4bec241a919_crop.jpeg"
              },
              {
                  "id": 4,
                  "name": "신동훈",
                  "profileImageUrl": "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/436/8142f53e51d2ec31bc0fa4bec241a919_crop.jpeg"
              },
              {
                  "id": 5,
                  "name": "유재석",
                  "profileImageUrl": "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/436/8142f53e51d2ec31bc0fa4bec241a919_crop.jpeg"
              },
              {
                  "id": 6,
                  "name": "박명수",
                  "profileImageUrl": "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/436/8142f53e51d2ec31bc0fa4bec241a919_crop.jpeg"
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
                  "id": 2,
                  "title": "리스트 제목",
                  "position": 1,
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
                  "id": 3,
                  "title": "리스트 제목",
                  "position": 2,
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
                  "id": 4,
                  "title": "리스트 제목2",
                  "position": 3,
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



