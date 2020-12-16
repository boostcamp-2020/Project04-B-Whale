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
  
  let semaphore = DispatchSemaphore(value: 1)
  let monitor = NWPathMonitor()
  let router: Routable
  
  var currentState: NWPath.Status!
  
  
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
      
      if path.status == .satisfied {
        guard self.currentState != .satisfied else { return }
        
        NotificationCenter.default.post(
          name: Notification.Name.networkChanged,
          object: nil,
          userInfo: ["networkState": true]
        )
        
        self.storedEndPoints()
      } else {
        guard self.currentState != .unsatisfied else { return }
        
        NotificationCenter.default.post(
          name: Notification.Name.networkChanged,
          object: nil,
          userInfo: ["networkState": false]
        )
      }
      
      self.currentState = path.status
    }
  }
  
  func storedEndPoints() {
    let realm = try! Realm()
    let result = realm.objects(OrderedEndPoint.self).sorted(byKeyPath: "date")
    let endPoints = Array(result)
    
    endPoints.forEach { endPoint in
      semaphore.wait()
     
      router.request(route: endPoint) { result in
        switch result {
        case .success(_):
          break
          
        case .failure(let error):
          print(error)
        }

        self.semaphore.signal()
      }
    }
    
    try! realm.write {
      realm.delete(result)
    }
  }
}
