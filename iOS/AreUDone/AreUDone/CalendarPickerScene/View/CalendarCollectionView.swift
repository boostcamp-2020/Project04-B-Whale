//
//  CalendarCollectionView.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/24.
//

import UIKit

final class CalendarCollectionView: UICollectionView {
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    
    configure()
  }
  
  
  // MARK: - Method
  
  func configure() {
    backgroundColor = .systemGroupedBackground
    isScrollEnabled = false
    
    layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    layer.cornerRadius = 10
    
    register(CalendarDateCollectionViewCell.self)
  }
}
