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
