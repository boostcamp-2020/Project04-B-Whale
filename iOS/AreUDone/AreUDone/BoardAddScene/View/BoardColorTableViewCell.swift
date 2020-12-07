//
//  BoardColorTableViewCell.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/07.
//

import UIKit

protocol BoardColorTableViewCellDelegate: AnyObject {
  
  func randomButtonTapped(cell: BoardColorTableViewCell)
}

final class BoardColorTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Property
  
  weak var delegate: BoardColorTableViewCellDelegate?
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.textAlignment = .left
    label.font = UIFont.nanumB(size: 18)
    label.text = "배경 색"
    
    return label
  }()
  private lazy var colorInfoLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
      
    label.font = UIFont.nanumR(size: 18)
    
    return label
  }()
  private lazy var colorImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    imageView.layer.cornerRadius = 10
    
    return imageView
  }()
  private lazy var randomButton: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isUserInteractionEnabled = true
    
    view.image = UIImage(systemName: "arrow.uturn.right.circle")
    view.tintColor = .black
    
    return view
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
  
  func update(with colorAsString: String) {
    colorInfoLabel.text = colorAsString
    colorImageView.backgroundColor = colorAsString.hexStringToUIColor()
  }
}


// MARK: - Extension Configure Method

private extension BoardColorTableViewCell {
  
  func configure() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(colorInfoLabel)
    contentView.addSubview(colorImageView)
    contentView.addSubview(randomButton)
    
    configureTitleLabel()
    configureRandomButton()
    configureColorImageView()
    configureColorInfoLabel()
    
  }
  
  func configureTitleLabel() {
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  func configureRandomButton() {
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(randomButtonTapped))
    randomButton.addGestureRecognizer(gestureRecognizer)
    
    NSLayoutConstraint.activate([
      randomButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      randomButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      randomButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.08),
      randomButton.heightAnchor.constraint(equalTo: randomButton.widthAnchor)
    ])
  }
    
  func configureColorImageView() {
    NSLayoutConstraint.activate([
      colorImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      colorImageView.trailingAnchor.constraint(equalTo: randomButton.leadingAnchor, constant: -10),
      colorImageView.widthAnchor.constraint(equalTo: randomButton.widthAnchor),
      colorImageView.heightAnchor.constraint(equalTo: colorImageView.widthAnchor)
    ])
  }
  
  func configureColorInfoLabel() {
    NSLayoutConstraint.activate([
      colorInfoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      colorInfoLabel.trailingAnchor.constraint(equalTo: colorImageView.leadingAnchor, constant: -10)
    ])
  }
}


// MARK: - Extension objc

private extension BoardColorTableViewCell {
  
  @objc func randomButtonTapped() {
    delegate?.randomButtonTapped(cell: self)
  }
}
