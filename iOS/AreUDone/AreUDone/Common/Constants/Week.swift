//
//  Week.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/09.
//

import Foundation

enum Week: CaseIterable {
  case sun, mon, tue, wed, thu, fri, sat
  
  var korean: String {
    switch self {
    case .sun: return "일"
    case .mon: return "월"
    case .tue: return "화"
    case .wed: return "수"
    case .thu: return "목"
    case .fri: return "금"
    case .sat: return "토"
    }
  }
}
