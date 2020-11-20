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
  
  class func storyboard(storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
    return UIStoryboard(name: storyboard.fileName, bundle: bundle)
  }
}
