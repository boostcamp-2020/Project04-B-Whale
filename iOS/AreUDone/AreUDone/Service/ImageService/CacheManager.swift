//
//  CacheManager.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/15.
//

import Foundation
import NetworkFramework

protocol CacheManageable {
  
  func load(imageName: String) -> Data?
}

struct CacheManager: CacheManageable {
  
  // MARK: - Method
  
  func load(imageName: String) -> Data? {
    guard
      let imagePath = urlOfCached(imageName: imageName),
      let data = try? Data(contentsOf: imagePath)
    else {
      return nil
    }
    return data
  }
  
  private func urlOfCached(imageName: String) -> URL? {
    guard let cachedPath = Path.cached else { return nil }
    let imagePath = cachedPath.appendingPathComponent(imageName)
    
    if FileManager.default.fileExists(atPath: imagePath.path) {
      return imagePath
    }
    return nil
  }
}
