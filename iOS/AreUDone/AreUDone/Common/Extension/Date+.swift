//
//  Date+.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/23.
//

import Foundation

extension Date {
  
  func toString(withDividerFormat dividerFormat: String = "-") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "yyyy\(dividerFormat)MM\(dividerFormat)dd"
    
    return dateFormatter.string(from: self)
  }
  
  func toStringWithTime(withDividerFormat dividerFormat: String = "-") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "yyyy\(dividerFormat)MM\(dividerFormat)dd HH:mm:ss"
    
    return dateFormatter.string(from: self)
  }
  
  func startOfMonth() -> Date? {
    let calendar = Calendar(identifier: .gregorian)
    guard
      let date = calendar.date(bySetting: .day, value: 1, of: self)
    else { return nil }
    
    return calendar.date(byAdding: .month, value: -1, to: date)
  }
  
  func endOfMonth() -> Date? {
    let calendar = Calendar(identifier: .gregorian)
    
    guard
      let date = calendar.date(bySetting: .day, value: 1, of: self)
    else { return nil }
    
    return calendar.date(byAdding: .day, value: -1, to: date)
  }
}
