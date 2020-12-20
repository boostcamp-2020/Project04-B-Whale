//
//  Day.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/24.
//

import Foundation

struct Day {
  
  let date: Date
  let number: String
  let isSelected: Bool
  let isWithinDisplayedMonth: Bool
}

extension Day: Hashable {
  
  static func == (lhs: Day, rhs: Day) -> Bool {
    return lhs.date == rhs.date &&
      lhs.isWithinDisplayedMonth == rhs.isWithinDisplayedMonth &&
      lhs.isSelected == rhs.isSelected
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(date)
    hasher.combine(isWithinDisplayedMonth)
    hasher.combine(isSelected)
  }
}


