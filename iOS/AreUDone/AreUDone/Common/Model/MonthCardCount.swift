//
//  MonthCardCount.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/08.
//

import Foundation

struct MonthCardCount: Codable {
  let cardCount: [DailyCardCount]
  
  struct DailyCardCount: Codable {
    let dueDate: String
    let count: Int
  }
}
