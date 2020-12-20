//
//  MemberSection.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/20.
//

import Foundation

enum MemberSection: CaseIterable {
  case invited
  case notInvited
  
  var description: String {
    switch self {
    case .invited:
      return "카드를 즐겨찾는 멤버"
      
    case .notInvited:
      return "카드를 즐겨찾지 않는 멤버"
    }
  }
}
