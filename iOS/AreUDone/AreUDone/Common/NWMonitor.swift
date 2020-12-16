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
  
  let monitorSemaphore = DispatchSemaphore(value: 1)
  let requestSemaphore = DispatchSemaphore(value: 1)
  let monitor = NWPathMonitor()
  let router: Routable
    
  
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
      self.monitorSemaphore.wait()
      
      if path.status == .satisfied {
        NotificationCenter.default.post(
          name: Notification.Name.networkChanged,
          object: nil,
          userInfo: ["networkState": true]
        )
        
        self.requestStoredEndPoints()
        self.monitorSemaphore.signal()
        
      } else {
        NotificationCenter.default.post(
          name: Notification.Name.networkChanged,
          object: nil,
          userInfo: ["networkState": false]
        )
        
        self.monitorSemaphore.signal()
      }
    }
  }
  
  func requestStoredEndPoints() {
    let realm = try! Realm()
    let result = realm.objects(OrderedEndPoint.self).sorted(byKeyPath: "date")
    let unmanagedEndPoints = Array(result).map { OrderedEndPoint(value: $0)}
    
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
