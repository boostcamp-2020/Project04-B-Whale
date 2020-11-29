//
//  CalendarCollectionView.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/24.
//

import UIKit

final class CalendarCollectionView: UICollectionView {
  

  // MARK: - Property
  
  private var swipeHandler: ((Direction) -> Void)!
  
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
    addGestureRecognizer()
  }
  
  override init(
    frame: CGRect,
    collectionViewLayout layout: UICollectionViewLayout
  ) {
    super.init(frame: frame, collectionViewLayout: layout)
    configure()
    addGestureRecognizer()
  }
  
  convenience init(
    frame: CGRect,
    collectionViewLayout layout: UICollectionViewLayout,
    swipeHandler: @escaping (Direction) -> Void
  ) {
    self.init(frame: frame, collectionViewLayout: layout)
    self.swipeHandler = swipeHandler

  }
  
  
  // MARK: - Method
  
  func configure() {
    backgroundColor = .systemGroupedBackground
    isScrollEnabled = false
    
    layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    layer.cornerRadius = 10
    
    register(CalendarDateCollectionViewCell.self)
  }

  func addGestureRecognizer() {
    let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwiped))
    leftSwipeGesture.direction = .left
    
    let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwiped))
    rightSwipeGesture.direction = .right
    
    addGestureRecognizer(leftSwipeGesture)
    addGestureRecognizer(rightSwipeGesture)
  }
  
  @objc func didSwiped(recognizer: UISwipeGestureRecognizer) {
    switch recognizer.direction {
    case .left:
      swipeHandler(.left)
      
    case .right:
      swipeHandler(.right)
      
    default:
      break
    }
  }
}
