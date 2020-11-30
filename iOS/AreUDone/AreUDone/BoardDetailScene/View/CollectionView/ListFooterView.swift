//
//  ListFooterView.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/29.
//

import UIKit

final class ListFooterView: UICollectionReusableView, Reusable {
  
  // MARK: - Property
  
  let titleLabel = UILabel()
  let baseView = UIView()
  
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  
  // MARK: - Method
  
  private func configure() {
    addSubview(baseView)
    baseView.addSubview(titleLabel)
    
    configureBaseView()
    configureTitle()
    
    baseView.layer.cornerRadius = 10
    
    baseView.layer.shadowColor = UIColor.black.cgColor
    baseView.layer.shadowOffset = .zero
    baseView.layer.shadowRadius = 1
    baseView.layer.shadowOpacity = 1
    baseView.backgroundColor = .white
    
    backgroundColor = .clear
  }
  
  func configureBaseView() {
    baseView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    
    baseView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      baseView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
      baseView.centerXAnchor.constraint(equalTo: centerXAnchor),
      baseView.widthAnchor.constraint(equalToConstant: bounds.width/3),
      baseView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
    ])
  }
  
  func configureTitle() {
    titleLabel.text = "카드 추가"
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: baseView.centerYAnchor),
    ])
  }
}


