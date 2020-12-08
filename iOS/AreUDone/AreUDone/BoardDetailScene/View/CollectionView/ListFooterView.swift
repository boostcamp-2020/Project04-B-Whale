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

    titleLabel.text = "카드 추가"
    titleLabel.font = UIFont.nanumB(size: 18)
    
    return titleLabel
  }()
  private let baseView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false

    view.layer.cornerRadius = 10
    
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = .zero
    view.layer.shadowRadius = 1
    view.layer.shadowOpacity = 1
    
    view.backgroundColor = .white
    
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
    NSLayoutConstraint.activate([
      baseView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
      baseView.centerXAnchor.constraint(equalTo: centerXAnchor),
      baseView.widthAnchor.constraint(equalToConstant: bounds.width/3),
      baseView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
    ])
  }
  
  func configureTitle() {
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: baseView.centerYAnchor),
    ])
  }
}


