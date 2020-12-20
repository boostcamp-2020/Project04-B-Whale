//
//  UIAlertController+.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/01.
//

import UIKit

extension UIAlertController {
  
  var defaultCancelButtonTitle: String {
    return "확인"
  }
  
  convenience init(alertType: AlertType,
                   alertStyle: UIAlertController.Style,
                   confirmAction: (() -> Void)? = nil,
                   cancelAction: (() -> Void)? = nil) {
    let alert = AlertFactory.alert(forType: alertType, style: alertStyle)
    
    self.init(title: alert.title,
              message: alert.message,
              preferredStyle: alertStyle)
    
    let cancelButtonTitle = alert.cancelTitle ?? defaultCancelButtonTitle
    let cancelAlertAction = UIAlertAction(
      title: cancelButtonTitle,
      style: .cancel
    ) { _ in
      cancelAction?()
    }
    
    self.addAction(cancelAlertAction)
    
    if let confirmActionTitle = alert.actionTitle {
      let confirmAlertAction = UIAlertAction(
        title: confirmActionTitle,
        style: .destructive
      ) { _ in
        confirmAction?()
      }
      self.addAction(confirmAlertAction)
    }
  }
}
