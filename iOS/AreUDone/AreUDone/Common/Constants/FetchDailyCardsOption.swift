//
//  FetchDailyCardsOption.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/10.
//

import Foundation

enum FetchDailyCardsOption {
  case allCard
  case myCard
  
  var value: String? {
    switch self {
    case .myCard:
      return "me"
      
    default:
      return nil
    }
  }
}
