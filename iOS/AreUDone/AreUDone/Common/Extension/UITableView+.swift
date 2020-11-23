//
//  UITableView+.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/23.
//

import UIKit

extension UITableView {
  
  func register<T: UITableViewCell>(_: T.Type) where T: Reusable {
    register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
  }
  
  func register<T: UITableViewCell>(_: T.Type) where T: Reusable, T: NibLoadable {
    let bundle = Bundle(for: T.self)
    let nib = UINib(nibName: T.nibName, bundle: bundle)
    
    register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
  }
}
