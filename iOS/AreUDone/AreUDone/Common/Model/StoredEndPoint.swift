//
//  OrderedEndPoint.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/16.
//

import Foundation
import NetworkFramework
import RealmSwift

final class StoredEndPoint: Object, EndPointable {
  
  // MARK: - Property
  
  @objc dynamic var date: Date = Date()
  
  var httpMethod: HTTPMethod? {
    return HTTPMethod(rawValue: httpMethodRawValue)
  }
  
  var headers: HTTPHeader? {
    return convert(list: headerList)
  }
  var bodies: HTTPBody? {
    return convert(list: bodyList)
  }
  var query: HTTPQuery? {
    return convert(list: queryList)
  }
  var baseURL: URLComponents {
    guard let url = URLComponents(string: environmentBaseURL) else { fatalError() }
    return url
  }
  
  @objc dynamic var environmentBaseURL: String = ""
  @objc dynamic var httpMethodRawValue: String = ""
  var headerList = List<dicFormat>()
  var bodyList = List<dicFormat>()
  var queryList = List<dicFormat>()
  
  
  // MARK: - Method
  
  private func convert(list: List<dicFormat>) -> [String: Any] {
    var lists = [String: Any]()
    Array(list).forEach {
      lists[$0.key] = $0.value
    }
    return lists
  }
}

final class dicFormat: Object {
  
  // MARK: - Property
  
  @objc dynamic var key: String = ""
  @objc dynamic var value: String = ""
}
