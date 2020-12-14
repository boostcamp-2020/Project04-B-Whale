//
//  Router.swift
//  NetworkFramework
//
//  Created by a1111 on 2020/11/19.
//

import Foundation

final public class Router: Routable {
  private var task: URLSessionTask?
  
  public init() { }
  
  public func request<T: Decodable>(route: EndPointable, completionHandler: @escaping ((Result<T,APIError>) -> Void)) {
    let session = URLSession.shared
    
    guard let request = configureRequest(from: route) else { return }
    task = session.dataTask(with: request) { data, response, error in
      
      guard let data = data else {
        completionHandler(.failure(.data))
        return
      }
      
      if let response = response as? HTTPURLResponse {
        let responseError = self.handleNetworkResponseError(response)
        
        switch responseError {
        case nil: // 200번
          
          if T.self == Data.self {
            completionHandler(.success(data as! T))
          } else {
            do {
              let model = try JSONDecoder().decode(T.self, from: data)
              completionHandler(.success(model))
            } catch {
              print(error)
              completionHandler(.failure(.decodingJSON))
            }
          }
        default: // 300~500번
          if let responseError = responseError {
            completionHandler(.failure(responseError))
          }
        }
      }
    }
    task?.resume()
  }
  
  public func request(route: EndPointable, completionHandler: @escaping ((Result<Void,APIError>) -> Void)) {
    let session = URLSession.shared
    
    guard let request = configureRequest(from: route) else { return }
    
    task = session.dataTask(with: request) { (data, response, error) in
      guard let _ = data else {
        completionHandler(.failure(.data))
        return
      }
      
      if let response = response as? HTTPURLResponse {
        let responseError = self.handleNetworkResponseError(response)
        
        switch responseError {
        case nil: // 200번
          completionHandler(.success(()))
        default: // 300~500번
          if let responseError = responseError {
            completionHandler(.failure(responseError))
          }
        }
      }
    }
    task?.resume()
  }
  
  public func request(route: EndPointable, imageName: String, completionHandler: @escaping ((Result<Data,APIError>) -> Void)) {
    guard let request = configureRequest(from: route) else { return }
    
    let session = URLSession.shared
    task = session.downloadTask(with: request) { (tmpImagePath, response, error) in
      
      guard let tmpImagePath = tmpImagePath, let cachedPath = Path.cached else { return }

      do {
        if let response = response as? HTTPURLResponse {
          let responseError = self.handleNetworkResponseError(response)
          
          switch responseError {
          case nil: // 200번
            let data = try Data(contentsOf: tmpImagePath)
            
            let newImagePath = cachedPath.appendingPathComponent("\(imageName)")
            try FileManager.default.moveItem(at: tmpImagePath, to: newImagePath)
            completionHandler(.success(data))
          default: // 300~500번
            if let responseError = responseError {
              completionHandler(.failure(responseError))
            }
          }
        }
        
      } catch {
        print(error)
      }
    }
    task?.resume()
  }
}
