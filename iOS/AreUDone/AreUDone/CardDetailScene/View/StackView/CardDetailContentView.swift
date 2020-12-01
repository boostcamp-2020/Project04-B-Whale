//
//  CardDetailContentView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/26.
//

import UIKit

final class CardDetailContentView: UIView {
  
  // MARK:- Property
  
  private lazy var titleLable: UILabel = {
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
    addSubview(titleLable)
    addSubview(contentLabel)
    
    configureTitleLabel()
    configureContentLabel()
  }
  
  func configureTitleLabel() {
    titleLable.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      titleLable.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      titleLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      titleLable.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
    ])
  }
  
  func configureContentLabel() {
    contentLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      contentLabel.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 4),
      contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
      contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
      contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
    ])
  }
}
