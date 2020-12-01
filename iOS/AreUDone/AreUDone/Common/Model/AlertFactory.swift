//
//  AlertFactory.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/01.
//

import UIKit

protocol AlertProtocol {
  var title: String? { get }
  var message: String? { get }
  var actionTitle: String? { get }
  var cancelTitle: String? { get }
  var style: UIAlertController.Style { get }
}

enum AlertType {
  case dataLoss
}

class AlertFactory {
  static func alert(forType type: AlertType, style: UIAlertController.Style) -> AlertProtocol {
    var alert: AlertProtocol
    switch type {
    case .dataLoss: alert = DataLossAlert(style: style)
    }
    
    return alert
  }
}

struct DataLossAlert: AlertProtocol {
  
  var title: String? { return "경고!!" }
  var message: String? { return "내용이 저장되지 않습니다." }
  var actionTitle: String? { return "확인" }
  var cancelTitle: String? { return "취소" }
  var style: UIAlertController.Style
}