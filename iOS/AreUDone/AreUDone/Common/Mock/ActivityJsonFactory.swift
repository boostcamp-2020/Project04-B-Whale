//
//  ActivityJsonFactory.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/02.
//

import Foundation
import NetworkFramework

struct ActivityTrueJsonFactory: JsonFactory {
  
  func loadJson(endPoint: EndPointable) -> Data? {
    switch endPoint {
    case ActivityEndPoint.fetchActivities:
      return """
      {
          "activities": [
              {
                  "id": 0,
                  "boardId": 1,
                  "content": "영민님이 보드를 만들었습니다.",
                  "createdAt": "2020-12-11"
              },
              {
                  "id": 1,
                  "boardId": 1,
                  "content": "영민님이 명렬님을 초대했습니다.",
                  "createdAt": "2020-12-12"
              }
          ]
      }
      """.data(using: .utf8)
    default:
      return nil
    }
  }
}


