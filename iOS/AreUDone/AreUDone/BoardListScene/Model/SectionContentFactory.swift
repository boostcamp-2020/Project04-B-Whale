//
//  SectionContentFactory.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import Foundation

protocol SectionContentsFactoryable {
  
  func load(index: Int) -> String
}

struct SectionContentsFactory: SectionContentsFactoryable {
  
  func load(index: Int) -> String {
    switch index {
    case 0:
      return "나의 보드"
    case 1:
      return "공유 보드"
    default:
      return ""
    }
  }
}
