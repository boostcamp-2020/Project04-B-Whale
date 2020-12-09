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
    label.font = UIFont.nanumR(size: 18)
    label.textColor = .label
    
    return label
  }()
  
  private lazy var cardCountView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .clear
    
    return view
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
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    cardCountView.backgroundColor = .clear
  }
  
  func updateCountView(with count: Int) {
    cardCountView.backgroundColor = cardCountColor(for: count)
  }
}


// MARK:- Extension

private extension CalendarDateCollectionViewCell {
  
  func configure() {
    addSubview(selectionBackgroundView)
    contentView.addSubview(numberLabel)
    contentView.addSubview(cardCountView)

    configureSelectionBackgroundView()
    configureNumberLabel()
    configureCardCountView()
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
    
    let size = frame.width - 20

    NSLayoutConstraint.activate([
      selectionBackgroundView.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
      selectionBackgroundView.centerXAnchor.constraint(equalTo: numberLabel.centerXAnchor),
      selectionBackgroundView.widthAnchor.constraint(equalToConstant: size),
      selectionBackgroundView.heightAnchor.constraint(equalTo: selectionBackgroundView.widthAnchor)
    ])
    
    selectionBackgroundView.layer.cornerRadius = size / 2
  }
  
  func configureCardCountView() {
    NSLayoutConstraint.activate([
      cardCountView.centerXAnchor.constraint(equalTo: numberLabel.centerXAnchor),
      cardCountView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      cardCountView.widthAnchor.constraint(equalToConstant: 7),
      cardCountView.heightAnchor.constraint(equalTo: cardCountView.widthAnchor)
    ])
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
  
  func cardCountColor(for count: Int) -> UIColor? {
    switch count {
    case 0:
      break
    case 1...2:
      return UIColor(red: 140/255, green: 241/255, blue: 152/255, alpha: 1.0)
    case 3...5:
      return UIColor(red: 57/255, green: 187/255, blue: 81/255, alpha: 1.0)
    case 6...10:
      return UIColor(red: 42/255, green: 147/255, blue: 62/255, alpha: 1.0)
    default:
      return UIColor(red: 28/255, green: 92/255, blue: 43/255, alpha: 1.0)
    }
    
    return nil
  }
}
