//
//  String+.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import Foundation

enum DateDeviderFormat: String {
  case dot = "."
  case dash = "-"
}

extension String {
  
  func toDateFormat(with deviderFormat: DateDeviderFormat) -> Date {
    let dateFormatter = DateFormatter()
    let devider = deviderFormat.rawValue
    dateFormatter.dateFormat = "yyyy\(devider)MM\(devider)dd"
    
    return dateFormatter.date(from: self) ?? Date()
  }
}
