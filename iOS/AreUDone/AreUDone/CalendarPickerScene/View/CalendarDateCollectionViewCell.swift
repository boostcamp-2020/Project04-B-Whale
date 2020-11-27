//
//  CalendarDateCollectionView.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/24.
//

import UIKit

final class CalendarDateCollectionViewCell: UICollectionViewCell, Reusable {
  
  // MARK:- Property
  
  private lazy var selectionBackgroundView: UIView = {
    let view = UIView()
    view.clipsToBounds = true
    view.layer.borderColor = UIColor.systemRed.cgColor
    view.layer.borderWidth = 2
    view.backgroundColor = .systemRed
    
    return view
  }()

  private lazy var numberLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    label.textColor = .label
    
    return label
  }()

  var day: Day? {
    didSet {
      guard let day = day else { return }

      numberLabel.text = day.number
      updateSelectionStatus()
    }
  }

  
  // MARK:- Initializer
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    configure()
  }
}


// MARK:- Extension

private extension CalendarDateCollectionViewCell {
  
  func configure() {
    addSubview(selectionBackgroundView)
    contentView.addSubview(numberLabel)

    configureSelectionBackgroundView()
    configureNumberLabel()
  }
  
  func configureNumberLabel() {
    numberLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
    ])
  }
  
  func configureSelectionBackgroundView() {
    selectionBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    
    let size = frame.width - 15

    NSLayoutConstraint.activate([
      selectionBackgroundView.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
      selectionBackgroundView.centerXAnchor.constraint(equalTo: numberLabel.centerXAnchor),
      selectionBackgroundView.widthAnchor.constraint(equalToConstant: size),
      selectionBackgroundView.heightAnchor.constraint(equalTo: selectionBackgroundView.widthAnchor)
    ])
    
    selectionBackgroundView.layer.cornerRadius = size / 2
  }
  
  func updateSelectionStatus() {
    guard let day = day else { return }

    if day.isSelected {
      applySelectedStyle()
    } else {
      applyDefaultStyle(isWithinDisplayedMonth: day.isWithinDisplayedMonth)
    }
  }

  func applySelectedStyle() {
    selectionBackgroundView.isHidden = false
  }

  func applyDefaultStyle(isWithinDisplayedMonth: Bool) {
    numberLabel.textColor = isWithinDisplayedMonth ? .label : .secondaryLabel
    selectionBackgroundView.isHidden = true
  }
}
