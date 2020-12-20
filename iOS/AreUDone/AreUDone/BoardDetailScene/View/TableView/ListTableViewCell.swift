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

    view.addShadow(
      offset: CGSize(width: 0, height: 0.5),
      radius: 0.3,
      opacity: 0.3
    )

    return view
  }()
  private lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    titleLabel.font = UIFont.nanumB(size: 18)
    
    return titleLabel
  }()
  private lazy var dueDateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.font = UIFont.nanumR(size: 15)
    
    return label
  }()
  private lazy var commentsCountLabel: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.titleLabel?.font = UIFont.nanumR(size: 15)
    button.setTitleColor(.black, for: .normal)
    button.setImage(UIImage(systemName: "text.bubble"), for: .normal)
    button.tintColor = .black
    
    return button
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
    dueDateLabel.text = card.dueDate.components(separatedBy: " ").first ?? ""
    commentsCountLabel.setTitle(" \(card.commentCount)", for: .normal)
  }
}


// MARK: - Extension Configure Method

private extension ListTableViewCell {
  
  func configure() {
    addSubview(baseView)
    baseView.addSubview(titleLabel)
    baseView.addSubview(dueDateLabel)
    baseView.addSubview(commentsCountLabel)
    
    configureView()
    configureBaseView()
    configureTitle()
    configureDueDateLabel()
    configureCommentCountsLabel()
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
      titleLabel.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 5),
      titleLabel.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 10),
    ])
  }
  
  func configureDueDateLabel() {
    NSLayoutConstraint.activate([
      dueDateLabel.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -5),
      dueDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
    ])
  }
  
  func configureCommentCountsLabel() {
    NSLayoutConstraint.activate([
      commentsCountLabel.centerYAnchor.constraint(equalTo: dueDateLabel.centerYAnchor),
      commentsCountLabel.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -10)
    ])
  }
}
