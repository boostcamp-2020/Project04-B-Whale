//
//  EndPointable+.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/16.
//

import Foundation
import NetworkFramework

extension EndPointable {
  
  func toDictionary() -> [String: Any] {
    let headers = makeRealmKeyValue(dictionary: self.headers)
    let bodies = makeRealmKeyValue(dictionary: self.bodies)
    let queries = makeRealmKeyValue(dictionary: self.query)

    let dic: [String: Any] = [
      "environmentBaseURL": self.environmentBaseURL,
      "httpMethodRawValue": self.httpMethod?.rawValue as Any,
      "headerList": headers as Any,
      "bodyList": bodies as Any,
      "queryList": queries as Any
    ]
    
    return dic
  }
  
  private func makeRealmKeyValue(dictionary: [String: Any]?) -> [[String: Any]]? {
    return dictionary?.map { (key, value) in
      ["key": key, "value": value]
    }
  }
}
