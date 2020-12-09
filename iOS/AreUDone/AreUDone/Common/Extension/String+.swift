//
//  String+.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import UIKit

enum DateDeviderFormat: String {
  case dot = "."
  case dash = "-"
}

extension String {
  
  func toDateFormat(with deviderFormat: DateDeviderFormat) -> Date {
    let dateFormatter = DateFormatter()
    let devider = deviderFormat.rawValue
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "yyyy\(devider)MM\(devider)dd"
    
    return dateFormatter.date(from: self) ?? Date()
  }
  
  func toDateAndTimeFormat(with deviderFormat: DateDeviderFormat = .dash) -> Date {
    let dateFormatter = DateFormatter()
    let devider = deviderFormat.rawValue
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "yyyy\(devider)MM\(devider)dd HH:mm:ss"
    
    return dateFormatter.date(from: self) ?? Date()
  }
  
  func toUIColor() -> UIColor {
      var rgbValue: UInt64 = 0
      let droppedString = self.dropFirst()

      Scanner(string: String(droppedString)).scanHexInt64(&rgbValue)
      
      return UIColor(
          red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
          green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
          blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
          alpha: CGFloat(1.0)
      )
  }
}
