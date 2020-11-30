//
//  DateLabel.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/23.
//

import UIKit

final class DateLabel: UILabel {
  
  // MARK:- Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  
  // MARK:- Method
  
  func update(withText text: String) {
    self.text = text
  }
}


// MARK:- Extension Configure Method

extension DateLabel {
  
  private func configure(){
    textAlignment = .center
    font = UIFont(name: "ChalkboardSE-Bold", size: 30)
  }
}
