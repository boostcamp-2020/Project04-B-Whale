//
//  SideBarHeaderFactory.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/02.
//

import Foundation

protocol SideBarHeaderContentsFactoryProtocol {
  
  func load(order: Int) -> (String, String)
}

final class SideBarHeaderContentsFactory: SideBarHeaderContentsFactoryProtocol {
  
  func load(order: Int) -> (String, String) {
    switch order {
    case 0:
      return ("person", "멤버")
      
    case 1:
      return ("list.bullet.rectangle", "활동")
    
    default:
      return ("없음", "")
    }
  }
}
