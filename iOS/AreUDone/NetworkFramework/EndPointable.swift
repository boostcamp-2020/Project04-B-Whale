//
//  EndPointable.swift
//  NetworkFramework
//
//  Created by a1111 on 2020/11/19.
//

import Foundation

public protocol EndPointable {
  var environmentBaseURL: String { get }
  var baseURL: URLComponents { get }
  var query: HTTPQuery? { get }
  var httpMethod: HTTPMethod? { get }
  var headers: HTTPHeader? { get }
  var bodies: HTTPBody? { get }
}

public enum HTTPMethod: String {
  case post,
       get,
       put
}
public typealias HTTPHeader = [String: String]
public typealias HTTPBody = [String: String]
public typealias HTTPQuery = [String: String]
