//
//  NWMonitor.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/16.
//

import Foundation
import Network
import NetworkFramework
import RealmSwift

final class NWMonitor {
  
  // MARK: - Property
  
  private let requestSemaphore = DispatchSemaphore(value: 1)
  private let monitor = NWPathMonitor()
  private let router: Routable
  
  private var currentState: NWPath.Status!
  private var isInitial = true
  
  
  // MARK: - Initializer
  
  init(router: Routable) {
    self.router = router
    
    configure()
  }
  
  func start() {
    let queue = DispatchQueue.global(qos: .background)
    monitor.start(queue: queue)
  }
}


// MARK: - Extension Configure Method

private extension NWMonitor {
  
  func configure() {
    monitor.pathUpdateHandler = { path in
      guard !self.isInitial else {
        self.currentState = path.status
        self.isInitial = false
        return
      }

      if path.status == .satisfied && self.currentState != .satisfied {
        NotificationCenter.default.post(
          name: Notification.Name.networkChanged,
          object: nil,
          userInfo: ["networkState": true]
        )
        self.requestStoredEndPoints()
        
      } else if path.status == .unsatisfied && self.currentState != .unsatisfied {
        NotificationCenter.default.post(
          name: Notification.Name.networkChanged,
          object: nil,
          userInfo: ["networkState": false]
        )
      }
      
      self.currentState = path.status
    }
  }
}


// MARK: - Extension

private extension NWMonitor {
  
  func requestStoredEndPoints() {
    let realm = try! Realm()
    let result = realm.objects(StoredEndPoint.self).sorted(byKeyPath: "date")
    let unmanagedEndPoints = Array(result).map { StoredEndPoint(value: $0)}
    
    try! realm.write {
      realm.delete(result)
    }
    
    unmanagedEndPoints.forEach { endPoint in
      requestSemaphore.wait()
      
      router.request(route: endPoint) { result in
        switch result {
        case .success(_):
          break
          
        case .failure(let error):
          print(error)
        }

        self.requestSemaphore.signal()
      }
    }
  }
}
