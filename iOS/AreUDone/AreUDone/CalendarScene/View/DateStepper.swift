//
//  DateStepper.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/24.
//

import UIKit

enum Direction {
  case right
  case left
}

protocol DateStepperDelegate: class {
  
  func arrowDidTapped(direction: Direction, with date: String)
  func dateLabelDidTapped(of date: String)
}

final class DateStepper: UIView {
  
  // MARK: - Property
  
  @IBOutlet weak var leftArrow: UIImageView!
  @IBOutlet weak var rightArrow: UIImageView!
  @IBOutlet weak var dateLabel: UILabel!
  
  weak var delegate: DateStepperDelegate?
  
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  
  // MARK:- Method
  
  func updateDate(date: String) {
    dateLabel.text = date
  }
}


// MARK:- Extension Configure Method

private extension DateStepper {
  
  func configure() {
    backgroundColor = .clear
    
    nibSetup()
    addingGesture()
  }
  
  func addingGesture() {
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dateLabelDidTapped))
    dateLabel.addGestureRecognizer(tapRecognizer)
    dateLabel.isUserInteractionEnabled = true
    
    let rightTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(leftArrowDidTapped))
    leftArrow.addGestureRecognizer(rightTapRecognizer)
    leftArrow.isUserInteractionEnabled = true
    
    let leftTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(rightArrowDidTapped))
    rightArrow.addGestureRecognizer(leftTapRecognizer)
    rightArrow.isUserInteractionEnabled = true
  }
}

// MARK:- Extension NibLoad

private extension DateStepper {
  
  func loadViewFromNib() -> UIView? {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: String(describing: DateStepper.self), bundle: bundle)
    return nib.instantiate(withOwner: self, options: nil).first! as? UIView
  }
  
  func nibSetup() {
    guard let view = loadViewFromNib() else { return }
    view.frame = bounds
    view.backgroundColor = .clear
    addSubview(view)
  }
}

// MARK:- Extension obj-c

private extension DateStepper {
  
  @objc func rightArrowDidTapped() {
    guard let date = dateLabel.text else { return }
    delegate?.arrowDidTapped(direction: .right, with: date)
  }
  
  @objc func leftArrowDidTapped() {
    guard let date = dateLabel.text else { return }
    delegate?.arrowDidTapped(direction: .left, with: date)
  }
  
  @objc func dateLabelDidTapped() {
    guard let date = dateLabel.text else { return }
    delegate?.dateLabelDidTapped(of: date)
  }
}
