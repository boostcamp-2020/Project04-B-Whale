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
  }
  
  override init(
    frame: CGRect,
    collectionViewLayout layout: UICollectionViewLayout
  ) {
    super.init(frame: frame, collectionViewLayout: layout)
    
    configure()
  }
  
  convenience init(
    frame: CGRect,
    collectionViewLayout layout: UICollectionViewLayout,
    swipeHandler: @escaping (Direction) -> Void
  ) {
    self.init(frame: frame, collectionViewLayout: layout)
    self.swipeHandler = swipeHandler
  }
}


// MARK:- Extension Configure Method

private extension CalendarCollectionView {
  
  func configure() {
    backgroundColor = .systemGroupedBackground
    isScrollEnabled = false
    
    layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    layer.cornerRadius = 10
    
    registerCell()
    addingGestureRecognizer()
  }
  
  func registerCell() {
    register(CalendarDateCollectionViewCell.self)
  }
  
  func addingGestureRecognizer() {
    let leftSwipeGesture = UISwipeGestureRecognizer(
      target: self,
      action: #selector(didSwiped)
    )
    leftSwipeGesture.direction = .left
    addGestureRecognizer(leftSwipeGesture)
    
    let rightSwipeGesture = UISwipeGestureRecognizer(
      target: self,
      action: #selector(didSwiped)
    )
    rightSwipeGesture.direction = .right
    addGestureRecognizer(rightSwipeGesture)
  }
}


// MARK:- Extension objc Method

private extension CalendarCollectionView {
  
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
