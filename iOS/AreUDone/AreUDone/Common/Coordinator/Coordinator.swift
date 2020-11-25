//
//  Coordinator.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/18.
//

import UIKit

protocol Coordinator {
  @discardableResult
  func start() -> UIViewController
}

protocol NavigationCoordinator {
  
  var navigationController: UINavigationController? { get set }
  
  @discardableResult
  func start() -> UIViewController
}

