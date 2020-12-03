//
//  SideBarBottomView.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/03.
//

import UIKit

protocol SideBarFooterViewDelegate: AnyObject {
  
  func baseViewTapped()
}

final class SideBarFooterView: UICollectionReusableView, Reusable {
  
  // MARK: - Property
  
  weak var delegate: SideBarFooterViewDelegate?
  
  private lazy var baseView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    view.backgroundColor = .white
    view.layer.cornerRadius = 10
    view.layer.borderColor = UIColor.black.cgColor
    
    return view
  }()
  
  private lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    return titleLabel
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
  
  
  // MARK: - Method
  
  func update(with title: String) {
    titleLabel.text = title
    if title.isEmpty { baseView.layer.borderWidth = 0 }
    else { baseView.layer.borderWidth = 1 }
  }
}


// MARK: - Extension Configure Method

private extension SideBarFooterView {
  
  func configure() {
    
    addSubview(baseView)
    baseView.addSubview(titleLabel)
    
    configureBaseView()
    configureTitleLabel()
  }
  
  func configureBaseView() {
    NSLayoutConstraint.activate([
      baseView.centerXAnchor.constraint(equalTo: centerXAnchor),
      baseView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
      baseView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95),
      baseView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
    ])
    
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(baseViewTapped))
    baseView.addGestureRecognizer(gestureRecognizer)
  }
  
  func configureTitleLabel() {
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: baseView.centerYAnchor)
    ])
  }
}


// MARK: - Extension objc

private extension SideBarFooterView {
  
  @objc func baseViewTapped() {
    delegate?.baseViewTapped()
  }
}
