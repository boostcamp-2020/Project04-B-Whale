//
//  ListService.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/19.
//

import Foundation
import NetworkFramework

protocol ListServiceProtocol {
  
}

class ListService {
  private let router: Routable
  
  init(router: Routable) {
    self.router = router
  }
}
