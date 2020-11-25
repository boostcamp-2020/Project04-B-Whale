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

class DateStepper: UIView {
  
  // MARK: - Property
  
  @IBOutlet weak var leftArrow: UIImageView!
  @IBOutlet weak var rightArrow: UIImageView!
  @IBOutlet weak var dateLabel: UILabel!
  
  weak var delegate: DateStepperDelegate?
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    xibSetup()
    backgroundColor = .clear
    
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
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    xibSetup()
  }
  
  func updateDate(date: String) {
    dateLabel.text = date
  }
  
  @objc private func rightArrowDidTapped() {
    guard let date = dateLabel.text else { return }
    delegate?.arrowDidTapped(direction: .right, with: date)
  }
  
  @objc private func leftArrowDidTapped() {
    guard let date = dateLabel.text else { return }
    delegate?.arrowDidTapped(direction: .left, with: date)
  }
  
  @objc private func dateLabelDidTapped() {
    guard let date = dateLabel.text else { return }
    delegate?.dateLabelDidTapped(of: date)
  }
  
  
  private func loadViewFromNib() -> UIView? {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: String(describing: DateStepper.self), bundle: bundle)
    return nib.instantiate(withOwner: self, options: nil).first! as? UIView
  }
  
  private func xibSetup() {
    guard let view = loadViewFromNib() else { return }
    view.frame = bounds
    view.backgroundColor = .clear
    addSubview(view)
  }
  
  
}
