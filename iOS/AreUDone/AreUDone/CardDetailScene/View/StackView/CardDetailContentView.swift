//
//  CardDetailContentView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/26.
//

import UIKit

final class CardDetailContentView: UIView {
  
  // MARK:- Property
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "내용"
    label.font = UIFont(name: "AmericanTypewriter-Bold", size: 20)
    
    return label
  }()
  
  private lazy var contentLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont(name: "AmericanTypewriter", size: 15)
    
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
  
  func update(content: String) {
    contentLabel.text = content
  }
}


// MARK:- Extension Configure Method

private extension CardDetailContentView {
  
  func configure() {
    addSubview(titleLabel)
    addSubview(contentLabel)
    
    configureTitleLabel()
    configureContentLabel()
  }
  
  func configureTitleLabel() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
    ])
  }
  
  func configureContentLabel() {
    contentLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
      contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
      contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
      contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
    ])
  }
}
