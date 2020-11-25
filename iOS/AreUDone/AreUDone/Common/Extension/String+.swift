//
//  String+.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import Foundation

extension String {
  
  func toDate() -> Date {
    let dateFormatter = DateFormatter()

    dateFormatter.dateFormat = "yyyy.MM.dd"
    
    return dateFormatter.date(from: self)!
  }
}
