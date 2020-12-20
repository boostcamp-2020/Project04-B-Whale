//
//  StubRouter.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/23.
//

import Foundation
import NetworkFramework

final class MockRouter: Routable {
  
  // MARK: - Property
  
  private let jsonFactory: JsonFactory?
  
  private(set) var urlRequest: URLRequest?
  
  // MARK: - Initializer
  
  init(jsonFactory: JsonFactory? = nil) {
    self.jsonFactory = jsonFactory
  }
  
  
  // MARK: - Method
  
  func request<T: Decodable>(route: EndPointable, completionHandler: @escaping ((Result<T, APIError>) -> Void)) {
    
    urlRequest = configureRequest(from: route)
    DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
      guard let data = self.jsonFactory?.loadJson(endPoint: route) else {
        completionHandler(.failure(.data))
        return
      }
      
      do {
        let model = try JSONDecoder().decode(T.self, from: data)
        completionHandler(.success(model))
      } catch {
        print(error)
        completionHandler(.failure(.decodingJSON))
      }
    }
  }
  
  func request(route: EndPointable, completionHandler: @escaping ((Result<Void, APIError>) -> Void)) {
    urlRequest = configureRequest(from: route)
    DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
      completionHandler(.success(()))
    }
  }
  
  func request(route: EndPointable, imageName: String, completionHandler: @escaping ((Result<Data,APIError>) -> Void)) {
    urlRequest = configureRequest(from: route)
    DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
      completionHandler(.success(Data()))
    }
  }
}
