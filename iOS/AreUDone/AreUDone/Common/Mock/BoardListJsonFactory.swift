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
                  "title": "졸업 작품",
                  "color": "#9c55b9"
              },
              {
                  "id": 1,
                  "title": "부스트 캠프 챌린지",
                  "color": "#f448b2"
              },
              {
                  "id": 2,
                  "title": "부스트 캠프 멤버십",
                  "color": "#bd1dce"
              },
              {
                  "id": 3,
                  "title": "공모전",
                  "color": "#ea58e1"
              },
              {
                  "id": 4,
                  "title": "면접 준비",
                  "color": "#2efff1"
              },
              {
                  "id": 5,
                  "title": "제주도 여행 계획",
                  "color": "#5d4a8f"
              },
              {
                  "id": 6,
                  "title": "미국 여행 계획",
                  "color": "#6a49ea"
              },
              {
                  "id": 7,
                  "title": "필리핀 여행 계획",
                  "color": "#15657c"
              }
          ],
          "invitedBoards": [
              {
                  "id": 8,
                  "title": "보드제목4",
                  "color": "#7dea88"
              },
              {
                  "id": 9,
                  "title": "보드제목5",
                  "color": "#c42451"
              },
              {
                  "id": 10,
                  "title": "보드제목6",
                  "color": "#a87a51"
              },
              {
                  "id": 11,
                  "title": "보드제목7",
                  "color": "#6a850e"
              }
          ]
      }
      """.data(using: .utf8)
    default:
      return nil
    }
  }
}
