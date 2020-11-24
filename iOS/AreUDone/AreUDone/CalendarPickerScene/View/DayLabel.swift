//
//  DayLabel.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/24.
//

import UIKit

class DayLabel: UILabel {
  
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
  
  
  // MARK:- Method
  
  private func configure() {
    font = .systemFont(ofSize: 12, weight: .bold)
    textColor = .secondaryLabel
    textAlignment = .center
  }
}
