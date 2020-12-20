//
//  CardDetailDueDateView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/26.
//

import UIKit

protocol CardDetailDueDateViewDelegate: AnyObject {
  
  func cardDetailDueDateEditButtonTapped(with dateString: String)
}


final class CardDetailDueDateView: UIView {
  
  // MARK:- Property
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "마감 날짜"
    label.font = UIFont.nanumB(size: 20)
    
    return label
  }()
  private lazy var dueDateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.nanumR(size: 15)
    
    return label
  }()
  private lazy var editButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(systemName: "calendar")
    button.setImage(image, for: .normal)
    
    return button
  }()
  
  weak var delegate: CardDetailDueDateViewDelegate?
  
  
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
    addSubview(titleLabel)
    addSubview(dueDateLabel)
    addSubview(editButton)
    
    configureView()
    configureTitleLabel()
    configureDueDateLabel()
    configureEditButton()
    addingTarget()
  }
  
  func configureView() {
    layer.borderWidth = 0.3
    layer.borderColor = UIColor.lightGray.cgColor
  }
  
  func configureTitleLabel() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
    ])
  }
  
  func configureDueDateLabel() {
    NSLayoutConstraint.activate([
      dueDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
      dueDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
      dueDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
      dueDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
    ])
  }
  
  func configureEditButton() {
    NSLayoutConstraint.activate([
      editButton.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
      editButton.widthAnchor.constraint(equalTo: editButton.heightAnchor),
      editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
      editButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
    ])
  }
  
  func addingTarget() {
    editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
  }
}


private extension CardDetailDueDateView {
  
  @objc func editButtonTapped() {
    guard let dateString = dueDateLabel.text else { return }
    delegate?.cardDetailDueDateEditButtonTapped(with: dateString)
  }
}
