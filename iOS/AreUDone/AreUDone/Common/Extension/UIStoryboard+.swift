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
    
    var fileName: String {
      return rawValue.capitalized
    }
  }
  
  static func load(storyboard: Storyboard, bundle: Bundle? = nil) -> Self {
    return .init(name: storyboard.fileName, bundle: bundle)
  }
}
