//
//  CardJsonFactory.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/23.
//

import Foundation
import NetworkFramework

struct CardTrueJsonFactory: JsonFactory {
  
  func loadJson(endPoint: EndPointable) -> Data? {
    switch endPoint {
    case CardEndPoint.fetchDailyCards:
      return """
            {
                "cards": [
                    {
                        "id": 1,
                        "title": "캘린더 끝내기",
                        "dueDate": "2020-11-18",
                        "commentCount": 11
                    },
                    {
                        "id": 2,
                        "title": "리스트 끝내기",
                        "dueDate": "2020-11-18",
                        "commentCount": 2
                    },
                    {
                        "id": 3,
                        "title": "보드 끝내기",
                        "dueDate": "2020-11-18",
                        "commentCount": 3
                    },
                    {
                        "id": 4,
                        "title": "카드 끝내기",
                        "dueDate": "2020-11-18",
                        "commentCount": 4
                    },
                    {
                        "id": 5,
                        "title": "유저 끝내기",
                        "dueDate": "2020-11-18",
                        "commentCount": 5
                    },
                    {
                        "id": 6,
                        "title": "모두 끝내기",
                        "dueDate": "2020-11-18",
                        "commentCount": 6
                    },
                    {
                        "id": 7,
                        "title": "재밌게 끝내기",
                        "dueDate": "2020-11-18",
                        "commentCount": 7
                    },
                    {
                        "id": 8,
                        "title": "재밌게 끝내기",
                        "dueDate": "2020-11-18",
                        "commentCount": 7
                    },
                    {
                        "id": 9,
                        "title": "재밌게 끝내기",
                        "dueDate": "2020-11-18",
                        "commentCount": 7
                    },
                    {
                        "id": 10,
                        "title": "재밌게 끝내기",
                        "dueDate": "2020-11-18",
                        "commentCount": 10
                    },
                    {
                        "id": 11,
                        "title": "재밌게 끝내기",
                        "dueDate": "2020-11-18",
                        "commentCount": 100
                    }
                ]
            }
            """.data(using: .utf8)
    case CardEndPoint.fetchDetailCard:
      return """
            {
                "id": 1,
                "title": "재밌게 끝내기",
                "content": "2주밖에 남지 않았습니다. 열심히 하겠습니다ㅠㅠ",
                "dueDate": "2020-12-02",
                "members": [
                        {
                            "id": 0,
                            "name": "서명렬",
                            "profileImageUrl": "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/436/8142f53e51d2ec31bc0fa4bec241a919_crop.jpeg"
                        },
                        {
                            "id": 1,
                            "name": "심영민",
                            "profileImageUrl": "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/436/8142f53e51d2ec31bc0fa4bec241a919_crop.jpeg"
                        },
                        {
                            "id": 2,
                            "name": "신동훈",
                            "profileImageUrl": "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/436/8142f53e51d2ec31bc0fa4bec241a919_crop.jpeg"
                        },
                    ],
                "comments" : [
                    {
                        "id": 1,
                        "content": "화이팅!123",
                        "createdAt": "2020-12-02",
                        "user": {
                            "id": 0,
                            "name": "서명렬",
                            "profileImageUrl": "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/436/8142f53e51d2ec31bc0fa4bec241a919_crop.jpeg"
                        }
                    },
                    {
                        "id": 2,
                        "content": "화이팅!123 가나다라마바사아자차카타파하 ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz",
                        "createdAt": "2020-12-02",
                        "user": {
                            "id": 0,
                            "name": "서명렬",
                            "profileImageUrl": "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/436/8142f53e51d2ec31bc0fa4bec241a919_crop.jpeg"
                        }
                    },
                    {
                        "id": 3,
                        "content": "화이팅!123",
                        "createdAt": "2020-12-02",
                        "user": {
                            "id": 1,
                            "name": "심영민",
                            "profileImageUrl": "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/436/8142f53e51d2ec31bc0fa4bec241a919_crop.jpeg"
                        }
                    },
                    {
                        "id": 4,
                        "content": "화이팅!123",
                        "createdAt": "2020-12-02",
                        "user": {
                            "id": 1,
                            "name": "심영민",
                            "profileImageUrl": "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/436/8142f53e51d2ec31bc0fa4bec241a919_crop.jpeg"
                        }
                    },
                    {
                        "id": 5,
                        "content": "웹도 화이팅!123",
                        "createdAt": "2020-12-02",
                        "user": {
                            "id": 3,
                            "name": "신동훈",
                            "profileImageUrl": "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/436/8142f53e51d2ec31bc0fa4bec241a919_crop.jpeg"
                        }
                    },
                    {
                        "id": 6,
                        "content": "웹도 화이팅!123",
                        "createdAt": "2020-12-02",
                        "user": {
                            "id": 4,
                            "name": "이건홍",
                            "profileImageUrl": "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/436/8142f53e51d2ec31bc0fa4bec241a919_crop.jpeg"
                        }
                    },
                    {
                        "id": 7,
                        "content": "웹도 화이팅!123",
                        "createdAt": "2020-12-02",
                        "user": {
                            "id": 5,
                            "name": "박수연",
                            "profileImageUrl": "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/436/8142f53e51d2ec31bc0fa4bec241a919_crop.jpeg"
                        }
                    }
                ],
                "board": {
                    "id": 0,
                    "title": "AreUDone Project"
                },
                "list": {
                    "id": 0,
                    "title": "Doing"
                }
            }
            """.data(using: .utf8)
    default:
      return nil
    }
  }
}

struct CardFalseJsonFactory: JsonFactory {
  func loadJson(endPoint: EndPointable) -> Data? {
    switch endPoint {
    case CardEndPoint.fetchDailyCards:
      return """
                   
            """.data(using: .utf8)
    default:
      return nil
    }
  }
}

/*
 
 {
     "id": 0,
     "content": "화이팅!123",
     "createdAt": "2020-12-02",
     "user": {
         "id": 0,
         "name": "서명렬",
         "profileImageUrl": ""
     }
 },
 */
