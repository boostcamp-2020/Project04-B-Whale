//
//  OrderedEndPoint.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/16.
//

import Foundation
import NetworkFramework
import RealmSwift

class StoredEndPoint: Object, EndPointable {
  @objc dynamic var date: Date = Date()
  
  var httpMethod: HTTPMethod? {
    return HTTPMethod(rawValue: httpMethodRawValue)
  }
  var headers: HTTPHeader? {
    var headers = [String: String]() // TODO: 메소드로 모듈화해보기
    Array(headersList).forEach {
      headers[$0.key] = $0.value
    }
    
    return headers
  }
  var bodies: HTTPBody? {
    var bodies = [String: Any]()
    Array(bodiesList).forEach {
      bodies[$0.key] = $0.value
    }
    
    return bodies
  }
  var query: HTTPQuery? {
    var queries = [String: String]()
    Array(queryList).forEach {
      queries[$0.key] = $0.value
    }
    
    return queries
  }
  var baseURL: URLComponents {
    guard let url = URLComponents(string: environmentBaseURL) else { fatalError() } // TODO: 예외처리로 바꿔주기
    return url
  }
  
  @objc dynamic var environmentBaseURL: String = ""
  @objc dynamic var httpMethodRawValue: String = ""
  var headersList = List<dic>()
  var bodiesList = List<dic>()
  var queryList = List<dic>()
}

class dic: Object {
  @objc dynamic var key: String = ""
  @objc dynamic var value: String = ""
}
