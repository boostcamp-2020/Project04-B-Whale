//
//  CardDetailContentView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/26.
//

import UIKit

protocol CardDetailContentViewDelegate: AnyObject {
  
  func cardDetailContentEditButtonTapped(with content: String)
}

final class CardDetailContentView: UIView {
  
  // MARK:- Property
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "내용"
    label.font = UIFont.nanumB(size: 20)
    
    return label
  }()
  private lazy var contentLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.font = UIFont.nanumR(size: 15)
    
    return label
  }()
  private lazy var editButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(systemName: "square.and.pencil")
    button.setImage(image, for: .normal)
    
    return button
  }()
  
  weak var delegate: CardDetailContentViewDelegate?
  
  
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
  
  func update(content: String?) {
    guard let content = content else { return }
    contentLabel.text = content
  }
}


// MARK:- Extension Configure Method

private extension CardDetailContentView {
  
  func configure() {
    addSubview(titleLabel)
    addSubview(contentLabel)
    addSubview(editButton)
    
    configureView()
    configureTitleLabel()
    configureContentLabel()
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
  
  func configureContentLabel() {
    NSLayoutConstraint.activate([
      contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
      contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
      contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
      contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
    ])
  }
  
  func configureEditButton() {
    NSLayoutConstraint.activate([
      editButton.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
      editButton.widthAnchor.constraint(equalTo: editButton.heightAnchor),
      editButton.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor),
      editButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
    ])
  }
  
  func addingTarget() {
    editButton.addTarget(
      self,
      action: #selector(editButtonTapped),
      for: .touchUpInside
    )
  }
}


// MARK:- Extension objc Method

private extension CardDetailContentView {
  
  @objc func editButtonTapped() {
    guard let content = contentLabel.text else { return }
    delegate?.cardDetailContentEditButtonTapped(with: content)
  }
}
