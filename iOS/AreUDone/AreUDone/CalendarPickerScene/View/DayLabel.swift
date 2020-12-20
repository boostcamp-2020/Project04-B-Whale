//
//  DayLabel.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/24.
//

import UIKit

final class DayLabel: UILabel {
  
  // MARK:- Initializer
  
  init(title: String) {
    super.init(frame: CGRect.zero)
    
    self.text = title
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }
}


// MARK:- Extension Configure Method

private extension DayLabel {
  
  func configure() {
    font = UIFont.nanumB(size: 12)
    textColor = .secondaryLabel
    textAlignment = .center
  }
}
