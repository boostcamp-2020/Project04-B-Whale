//
//  ImageService.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/03.
//

import Foundation
import NetworkFramework

protocol ImageServiceProtocol {
  
  func fetchImage(
    with url: String,
    imageName: String,
    completionHandler: @escaping ((Result<Data, APIError>) -> Void)
  )
}

final class ImageService: ImageServiceProtocol {
 
  // MARK: - Property
  
  private let router: Routable
  private let cacheManager: CacheManageable
  
  
  // MARK: - Initializer
  
  init(router: Routable, cacheManager: CacheManageable) {
    self.router = router
    self.cacheManager = cacheManager
  }
  
  
  // MARK: - Method
  
  func fetchImage(
    with url: String,
    imageName: String,
    completionHandler: @escaping ((Result<Data, APIError>) -> Void)
  ) {
    if let data = cacheManager.load(imageName: imageName) {
      completionHandler(.success(data))
      return
    }
    router.request(route: ImageEndPoint.fetchImage(url: url), imageName: imageName) { result in
      completionHandler(result)
    }
  }
}
