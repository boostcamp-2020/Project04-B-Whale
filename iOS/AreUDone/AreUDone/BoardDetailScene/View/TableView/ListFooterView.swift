//
//  ListFooterView.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/29.
//

import UIKit

protocol ListFooterViewDelegate: AnyObject {
  
  func baseViewDidTapped()
}

final class ListFooterView: UIView {
  
  // MARK: - Property

  private let buttonView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false

    view.layer.cornerRadius = 10
    view.addShadow(offset: .zero, radius: 1, opacity: 1)
    view.backgroundColor = .white
    
    return view
  }()
  
  private lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    titleLabel.text = "카드 추가"
    titleLabel.font = UIFont.nanumB(size: 18)
    
    return titleLabel
  }()
  
  
  private var presentCardAddHandler: ((Int) -> Void)?
  weak var delegate: ListFooterViewDelegate?

  
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
    addSubview(buttonView)
    buttonView.addSubview(titleLabel)
    
    configureView()
    configureBaseView()
    configureTitle()
  }
  
  func configureView() {
    backgroundColor = .clear
  }
  
  func configureBaseView() {
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(baseViewDidTapped))
    buttonView.addGestureRecognizer(gestureRecognizer)

    
    NSLayoutConstraint.activate([
      buttonView.centerXAnchor.constraint(equalTo: centerXAnchor),
      buttonView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
      buttonView.widthAnchor.constraint(equalToConstant: 100),
      buttonView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
  
  func configureTitle() {
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
    ])
  }
}


// MARK: - Extension objc

private extension ListFooterView {
  
  @objc func baseViewDidTapped() {
    delegate?.baseViewDidTapped()
  }
}

