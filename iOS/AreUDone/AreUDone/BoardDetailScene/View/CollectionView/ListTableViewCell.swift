//
//  ListTableViewCell.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import UIKit

final class ListTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Property
  
  private let baseView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false

    view.backgroundColor = .white
    view.layer.cornerRadius = 5

    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    view.layer.shadowRadius = 0.3
    view.layer.shadowOpacity = 0.3
    return view
  }()
  
  private lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    titleLabel.font = UIFont.nanumR(size: 18)
    
    return titleLabel
  }()
  
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configure()
  }
  
  
  // MARK: - Method
  
  func update(with card: Card) {
    titleLabel.text = card.title
  }
}


// MARK: - Extension Configure Method

private extension ListTableViewCell {
  
  func configure() {
    addSubview(baseView)
    baseView.addSubview(titleLabel)
    
    configureView()
    configureBaseView()
    configureTitle()
  }
  
  func configureView() {
    backgroundColor = .clear
    selectionStyle = .none
  }
  
  func configureBaseView() {
    NSLayoutConstraint.activate([
      baseView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      baseView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
      baseView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
      baseView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
    ])
  }
  
  func configureTitle() {
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
}
