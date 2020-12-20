//
//  CardDetailLocationView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/01.
//

import UIKit

final class CardDetailLocationView: UIView {

  // MARK:- Property
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "카드 위치"
    label.font = UIFont.nanumB(size: 20)
    
    return label
  }()
  private lazy var listNameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.nanumB(size: 16)
    
    return label
  }()
  private lazy var boardNameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.nanumB(size: 16)
    
    return label
  }()
  private lazy var listDescriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.nanumR(size: 14)
    label.text = "리스트에 있습니다"
    
    return label
  }()
  private lazy var boardDescriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.nanumR(size: 14)
    label.text = "보드에 있습니다"
    
    return label
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
  
  func updateListNameLabel(with title: String) {
    let text = title
    listNameLabel.text = text
  }
  
  func updateBoardNameLabel(with title: String) {
    let text = title
    boardNameLabel.text = text
  }
}


// MARK:- Extension Configure Method

private extension CardDetailLocationView {
  
  func configure() {
    addSubview(titleLabel)
    addSubview(listNameLabel)
    addSubview(boardNameLabel)
    addSubview(listDescriptionLabel)
    addSubview(boardDescriptionLabel)
    
    configureView()
    configureTitleLabel()
    configureListNameLabel()
    configureBoardNameLabel()
    configureListDescriptionLabel()
    configureBoardDescriptionLabel()
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
  
  func configureListNameLabel() {
    NSLayoutConstraint.activate([
      listNameLabel.topAnchor.constraint(equalTo: boardNameLabel.bottomAnchor, constant: 5),
      listNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
      listNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
    ])
  }
  
  func configureBoardNameLabel() {
    NSLayoutConstraint.activate([
      boardNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
      boardNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
    ])
  }
  
  func configureListDescriptionLabel() {
    NSLayoutConstraint.activate([
      listDescriptionLabel.leadingAnchor.constraint(equalTo: listNameLabel.trailingAnchor, constant: 5),
      listDescriptionLabel.firstBaselineAnchor.constraint(equalTo: listNameLabel.firstBaselineAnchor),
      listDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
    ])
  }
  
  func configureBoardDescriptionLabel() {
    NSLayoutConstraint.activate([
      boardDescriptionLabel.leadingAnchor.constraint(equalTo: boardNameLabel.trailingAnchor, constant: 5),
      boardDescriptionLabel.firstBaselineAnchor.constraint(equalTo: boardNameLabel.firstBaselineAnchor),
      boardDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
    ])
  }
}
