//
//  UIStoryboard+.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/18.
//

import UIKit

extension UIStoryboard {
  
  enum Storyboard: String {
    case signin
    case calendar
    case cardDetail
    case boardList
    case boardAdd
    case boardDetail
    case contentInput
    case invitation
    
    var fileName: String {
      return (String(rawValue.first?.uppercased() ?? "")) + String(rawValue.dropFirst())
    }
  }
  
  static func load(storyboard: Storyboard, bundle: Bundle? = nil) -> Self {
    return .init(name: storyboard.fileName, bundle: bundle)
  }
}
