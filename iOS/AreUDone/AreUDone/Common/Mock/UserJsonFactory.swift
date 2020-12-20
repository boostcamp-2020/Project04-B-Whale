//
//  UserJsonFactory.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/04.
//

import Foundation
import NetworkFramework

struct UserJsonFactory: JsonFactory {
  
  func loadJson(endPoint: EndPointable) -> Data? {
    switch endPoint {
    case UserEndPoint.fetchMyInfo:
      return
        """
        {
            "id": 3,
            "name": "서명렬",
            "profileImageUrl": "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/436/8142f53e51d2ec31bc0fa4bec241a919_crop.jpeg"
        }
        """.data(using: .utf8)
      
    default:
      return nil
    }
  }
}
