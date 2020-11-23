//
//  NibLoadable.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/23.
//

import UIKit

protocol NibLoadable {
  
  static var nibName: String { get }
}

extension NibLoadable where Self: UIView {
  
  static var nibName: String {
    return NSStringFromClass(self).components(separatedBy: ".").last!
  }
}
