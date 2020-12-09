//
//  CalendarPickerHeaderView.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/24.
//

import UIKit

final class CalendarPickerHeaderView: UIView {
  
  // MARK:- Property
  
  private lazy var monthLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.nanumB(size: 24)
    
    return label
  }()
  
  private lazy var timeSettingButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("시간 설정", for: .normal)
    button.titleLabel?.font = UIFont.nanumB(size: 15)
    button.setTitleColor(.systemBlue, for: .normal)
    
    return button
  }()
  
  private lazy var dayOfWeekStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.distribution = .fillEqually
    
    return stackView
  }()

  private lazy var separatorView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.label.withAlphaComponent(0.2)
    
    return view
  }()

  private lazy var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.locale = Locale(identifier: "ko")
    dateFormatter.dateFormat = "yyyy년 M월"
    
    return dateFormatter
  }()

  var baseDate = Date() {
    didSet {
      monthLabel.text = dateFormatter.string(from: baseDate)
    }
  }

  
  // MARK:- Initializer
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init() {
    super.init(frame: CGRect.zero)
    
    configure()
  }
}


// MARK:- Extension

private extension CalendarPickerHeaderView {
  
  func configure() {
    addSubview(monthLabel)
    addSubview(separatorView)
    addSubview(dayOfWeekStackView)
    addSubview(timeSettingButton)

    configureView()
    configureMonthLabel()
    configureTimeSettingButton()
    configureSeparatorView()
    configureDayOfWeekStackView()
    
    addingTarget()
  }
  
  func configureView() {
    translatesAutoresizingMaskIntoConstraints = false

    backgroundColor = .systemGroupedBackground

    layer.maskedCorners = [
      .layerMinXMinYCorner,
      .layerMaxXMinYCorner
    ]
    layer.cornerCurve = .continuous
    layer.cornerRadius = 15
  }
  
  func configureMonthLabel() {
    NSLayoutConstraint.activate([
      monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
      monthLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      monthLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
    ])
  }
  
  func configureTimeSettingButton() {
    NSLayoutConstraint.activate([
      timeSettingButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
      timeSettingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
    ])
  }
  
  func configureSeparatorView() {
    NSLayoutConstraint.activate([
      separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
      separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
      separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
      separatorView.heightAnchor.constraint(equalToConstant: 1)
    ])
  }
  
  func configureDayOfWeekStackView() {
    for dayNumber in 1...7 {
      let title = dayOfWeekLetter(for: dayNumber)

      let dayLabel = DayLabel(title: title)
      dayOfWeekStackView.addArrangedSubview(dayLabel)
    }
    
    NSLayoutConstraint.activate([
      dayOfWeekStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      dayOfWeekStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      dayOfWeekStackView.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -5),
    ])
  }
  
  func dayOfWeekLetter(for dayNumber: Int) -> String {
    switch dayNumber {
    case 1:
      return "일"
    case 2:
      return "월"
    case 3:
      return "화"
    case 4:
      return "수"
    case 5:
      return "목"
    case 6:
      return "금"
    case 7:
      return "토"
    default:
      return ""
    }
  }
  
  func addingTarget() {
    timeSettingButton.addTarget(
      self,
      action: #selector(timeSettingButtonTapped),
      for: .touchUpInside
    )
  }
}


// MARK:- Extension obj-c

private extension CalendarPickerHeaderView {
  
  @objc private func timeSettingButtonTapped() {
    
  }
}
