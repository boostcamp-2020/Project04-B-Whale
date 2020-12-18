//
//  TitleChangeable.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/10.
//

import Foundation

protocol TitleChangeable {
  
  var text: String { get }
}

enum CardSegment: CaseIterable, TitleChangeable {
  case allCard
  case myCard
  
  var text: String {
    switch self {
    case .allCard:
      return "전체 카드"
      
    case .myCard:
      return "나의 카드"
    }
  }
}

enum BoardSegment: CaseIterable, TitleChangeable {
  case myBoard
  case invitedBoard
  
  var text: String {
    switch self {
    case .myBoard:
      return "나의 보드"
      
    case .invitedBoard:
      return "공유 보드"
    }
  }
}
