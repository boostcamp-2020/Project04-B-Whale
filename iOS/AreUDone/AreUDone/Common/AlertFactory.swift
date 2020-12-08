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
  case delete
}

class AlertFactory {
  
  static func alert(forType type: AlertType, style: UIAlertController.Style) -> AlertProtocol {
    var alert: AlertProtocol
    switch type {
    case .dataLoss: alert = DataLossAlert(style: style)
      
    case .delete: alert = DeleteAlert(style: style)
    }
    
    return alert
  }
}

struct DataLossAlert: AlertProtocol {
  
  var title: String? { return "변경사항이 저장되지 않습니다." }
  var message: String? { return nil }
  var actionTitle: String? { return "버리기" }
  var cancelTitle: String? { return "취소" }
  var style: UIAlertController.Style
}

struct DeleteAlert: AlertProtocol {
  
  var title: String? { return "해당 댓글을 삭제하시겠습니까?"}
  var message: String? { return nil }
  var actionTitle: String? { return "삭제"}
  var cancelTitle: String? { return "취소"}
  var style: UIAlertController.Style
}
