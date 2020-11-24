//
//  CalendarPickerHeaderView.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/24.
//

import UIKit

class CalendarPickerHeaderView: UIView {
  lazy var monthLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 26, weight: .bold)
    label.text = "Month"
    label.accessibilityTraits = .header
    label.isAccessibilityElement = true
    return label
  }()

  lazy var closeButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false

    let configuration = UIImage.SymbolConfiguration(scale: .large)
    let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: configuration)
    button.setImage(image, for: .normal)

    button.tintColor = .secondaryLabel
    button.contentMode = .scaleAspectFill
    button.isUserInteractionEnabled = true
    button.isAccessibilityElement = true
    button.accessibilityLabel = "Close Picker"
    return button
  }()

  lazy var dayOfWeekStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.distribution = .fillEqually
    return stackView
  }()

  lazy var separatorView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.label.withAlphaComponent(0.2)
    return view
  }()

  private lazy var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.locale = Locale.autoupdatingCurrent
    dateFormatter.setLocalizedDateFormatFromTemplate("MMMM y")
    return dateFormatter
  }()

  var baseDate = Date() {
    didSet {
      monthLabel.text = dateFormatter.string(from: baseDate)
    }
  }

  var exitButtonTappedCompletionHandler: (() -> Void)

  init(exitButtonTappedCompletionHandler: @escaping (() -> Void)) {
    self.exitButtonTappedCompletionHandler = exitButtonTappedCompletionHandler

    super.init(frame: CGRect.zero)

    translatesAutoresizingMaskIntoConstraints = false

    backgroundColor = .systemGroupedBackground

    layer.maskedCorners = [
      .layerMinXMinYCorner,
      .layerMaxXMinYCorner
    ]
    layer.cornerCurve = .continuous
    layer.cornerRadius = 15

    addSubview(monthLabel)
    addSubview(closeButton)
    addSubview(dayOfWeekStackView)
    addSubview(separatorView)

    for dayNumber in 1...7 {
      let dayLabel = UILabel()
      dayLabel.font = .systemFont(ofSize: 12, weight: .bold)
      dayLabel.textColor = .secondaryLabel
      dayLabel.textAlignment = .center
      dayLabel.text = dayOfWeekLetter(for: dayNumber)

      // VoiceOver users don't need to hear these days of the week read to them, nor do SwitchControl or Voice Control users need to select them
      // If fact, they get in the way!
      // When a VoiceOver user highlights a day of the month, the day of the week is read to them.
      // That method provides the same amount of context as this stack view does to visual users
      dayLabel.isAccessibilityElement = false
      dayOfWeekStackView.addArrangedSubview(dayLabel)
    }

    closeButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
  }

  @objc func didTapExitButton() {
    exitButtonTappedCompletionHandler()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func dayOfWeekLetter(for dayNumber: Int) -> String {
    switch dayNumber {
    case 1:
      return "S"
    case 2:
      return "M"
    case 3:
      return "T"
    case 4:
      return "W"
    case 5:
      return "T"
    case 6:
      return "F"
    case 7:
      return "S"
    default:
      return ""
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    NSLayoutConstraint.activate([
      monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
      monthLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      monthLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: 5),

      closeButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
      closeButton.heightAnchor.constraint(equalToConstant: 28),
      closeButton.widthAnchor.constraint(equalToConstant: 28),
      closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),

      dayOfWeekStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      dayOfWeekStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      dayOfWeekStackView.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -5),

      separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
      separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
      separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
      separatorView.heightAnchor.constraint(equalToConstant: 1)
    ])
  }
}

