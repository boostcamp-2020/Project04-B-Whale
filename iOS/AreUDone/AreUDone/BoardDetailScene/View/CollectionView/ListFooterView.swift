//
//  ListFooterView.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/29.
//

import UIKit

final class ListFooterView: UICollectionReusableView, Reusable {
  
  // MARK: - Property
  
  private lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    return titleLabel
  }()
  private let baseView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false

    return view
  }()
  
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
}
 

// MARK: - Extension Configure Method

private extension ListFooterView {
    
  private func configure() {
    addSubview(baseView)
    baseView.addSubview(titleLabel)
    
    configureView()
    configureBaseView()
    configureTitle()
  }
  
  func configureView() {
    backgroundColor = .clear
  }
  
  func configureBaseView() {
    baseView.layer.cornerRadius = 10
    
    baseView.layer.shadowColor = UIColor.black.cgColor
    baseView.layer.shadowOffset = .zero
    baseView.layer.shadowRadius = 1
    baseView.layer.shadowOpacity = 1
    
    baseView.backgroundColor = .white
    
    NSLayoutConstraint.activate([
      baseView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
      baseView.centerXAnchor.constraint(equalTo: centerXAnchor),
      baseView.widthAnchor.constraint(equalToConstant: bounds.width/3),
      baseView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
    ])
  }
  
  func configureTitle() {
    titleLabel.text = "카드 추가"
    
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: baseView.centerYAnchor),
    ])
  }
}


