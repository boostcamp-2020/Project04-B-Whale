//
//  NotificationName.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/09.
//

import Foundation

extension Notification.Name {
  
  static let listWillDragged = Notification.Name("ListWillDragged")
  static let listDidDragged = Notification.Name("ListDidDragged")
  static let networkChanged = Notification.Name("networkChanged")
  static let cardWillDragged = Notification.Name("CardWillDragged")
  static let cardDidDragged = Notification.Name("CardDidDragged")
  static let foreground = Notification.Name("foreground")
  static let background = Notification.Name("background")
}
