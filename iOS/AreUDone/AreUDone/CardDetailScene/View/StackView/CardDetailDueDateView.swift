//
//  CardDetailDueDateView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/26.
//

import UIKit

final class CardDetailDueDateView: UIView {
  
  // MARK:- Property
  
  private lazy var titleLable: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "마감 날짜"
    label.font = UIFont(name: "AmericanTypewriter-Bold", size: 20)
    
    return label
  }()
  
  private lazy var dueDateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.font = UIFont(name: "AmericanTypewriter", size: 15)
    
    return label
  }()
  
  private lazy var editButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(systemName: "calendar")
    button.setImage(image, for: .normal)
    
    return button
  }()
  
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
  
  func update(dueDate: String) {
    dueDateLabel.text = dueDate
  }
}

// MARK:- Extension Configure Method

private extension CardDetailDueDateView {
  
  func configure() {
    layer.borderWidth = 0.3
    layer.borderColor = UIColor.lightGray.cgColor
    
    addSubview(titleLable)
    addSubview(dueDateLabel)
    addSubview(editButton)
    
    configureTitleLabel()
    configureDueDateLabel()
    configureEditButton()
  }
  
  func configureTitleLabel() {
    NSLayoutConstraint.activate([
      titleLable.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      titleLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      titleLable.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
    ])
  }
  
  func configureDueDateLabel() {
    NSLayoutConstraint.activate([
      dueDateLabel.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 4),
      dueDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
      dueDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
      dueDateLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
    ])
  }
  
  func configureEditButton() {
    NSLayoutConstraint.activate([
      editButton.leadingAnchor.constraint(equalTo: dueDateLabel.trailingAnchor, constant: 5),
      editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
      editButton.centerYAnchor.constraint(equalTo: dueDateLabel.centerYAnchor)
    ])
  }
}
