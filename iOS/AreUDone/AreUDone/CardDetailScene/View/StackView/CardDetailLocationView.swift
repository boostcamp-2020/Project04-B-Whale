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
    label.font = UIFont(name: "AmericanTypewriter-Bold", size: 20)
    
    return label
  }()
  
  private lazy var listNameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont(name: "AmericanTypewriter", size: 14)
    
    return label
  }()
  
  private lazy var boardNameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont(name: "AmericanTypewriter", size: 14)
    
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
  
  func updateListNameLabel(with title: String) {
    let text = title + " 리스트에 있습니다."
    listNameLabel.text = text
  }
  
  func updateBoardNameLabel(with title: String) {
    let text = title + " 보드에 있습니다."
    boardNameLabel.text = text
  }
}


private extension CardDetailLocationView {
  
  func configure() {
    addSubview(titleLabel)
    addSubview(listNameLabel)
    addSubview(boardNameLabel)
    
    configureTitleLabel()
    configureListNameLabel()
    configureBoardNameLabel()
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
      listNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
      listNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
      listNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
    ])
  }
  
  func configureBoardNameLabel() {
    NSLayoutConstraint.activate([
      boardNameLabel.topAnchor.constraint(equalTo: listNameLabel.bottomAnchor, constant: 5),
      boardNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
      boardNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
      boardNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
    ])
  }
}
