//
//  Date+.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/23.
//

import Foundation

extension Date {
  
  func toString(withDividerFormat dividerFormat: DateDeviderFormat = .dash) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    let divider = dividerFormat.rawValue
    dateFormatter.dateFormat = "yyyy\(divider)MM\(divider)dd"
    
    return dateFormatter.string(from: self)
  }
  
  func toStringWithTime(withDividerFormat dividerFormat: DateDeviderFormat = .dash) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    let divider = dividerFormat.rawValue
    dateFormatter.dateFormat = "yyyy\(divider)MM\(divider)dd HH:mm:ss"
    
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
