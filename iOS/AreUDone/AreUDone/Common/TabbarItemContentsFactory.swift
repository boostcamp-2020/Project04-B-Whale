//
//  TabbarItemFactory.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import Foundation

protocol TabbarItemFactoryProtocol {
  
  func load(order: Int) -> (String, String)
}

final class TabbarItemContentsFactory {
  
  func load(order: Int) -> (String, String) {
    switch order {
    case 0:
      return ("캘린더", "calendar")
    case 1:
      return ("보드", "list.bullet.rectangle")
    case 2:
      return ("설정", "gear")
    default:
      return ("없음", "")
    }
  }
}
