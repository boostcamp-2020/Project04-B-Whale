//
//  Date+.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/23.
//

import Foundation

extension Date {
  
  func toString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd"
    
    return dateFormatter.string(from: self)
  }
}
