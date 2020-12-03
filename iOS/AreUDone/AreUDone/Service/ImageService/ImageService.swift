//
//  ImageService.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/03.
//

import Foundation
import NetworkFramework

protocol ImageServiceProtocol {
  
  func fetchImage(with url: String, completionHandler: @escaping ((Result<Data, APIError>) -> Void))
}

final class ImageService: ImageServiceProtocol {
 
  
  // MARK: - Property
  
  private let router: Routable
  
  
  // MARK: - Initializer
  
  init(router: Routable) {
    self.router = router
  }
  
  
  // MARK: - Method
  
  func fetchImage(with url: String, completionHandler: @escaping ((Result<Data, APIError>) -> Void)) {
    router.request(route: ImageEndPoint.fetchImage(url: url)) { result in
      completionHandler(result)
    }
  }
}
