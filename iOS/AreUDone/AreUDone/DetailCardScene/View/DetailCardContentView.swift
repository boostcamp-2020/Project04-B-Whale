//
//  DetailCardContentView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/26.
//

import UIKit

final class DetailCardContentView: UITableViewCell, Reusable {
  
  // MARK:- Property
  
  private lazy var titleLable: UILabel = {
    let label = UILabel()
    label.text = "내용"
    label.font = UIFont(name: "Chalkduster", size: 20)
    
    return label
  }()
  
  private lazy var contentLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    
    return label
  }()
  
  // MARK:- Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configure()
  }

  
  // MARK:- Method
  
  func update(content: String) {
    contentLabel.text = content
  }
  
  
}


private extension DetailCardContentView {
  
  func configure() {
    backgroundColor = .green
    
    addSubview(titleLable)
    addSubview(contentLabel)
    
    configureTitleLabel()
    configureContentLabel()
  }
  
  func configureTitleLabel() {
    titleLable.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      titleLable.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      titleLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
      titleLable.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
    ])
  }
  
  func configureContentLabel() {
    contentLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      contentLabel.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 4),
      contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
      contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
      contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
    ])
  }
}
