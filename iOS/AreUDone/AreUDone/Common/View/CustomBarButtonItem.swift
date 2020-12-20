//
//  BackButton.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/29.
//

import UIKit

final class CustomBarButtonItem: UIBarButtonItem {
  
  // MARK: - Property

  var handler: () -> Void
  private lazy var button: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false

    button.setImage(UIImage(systemName: imageName), for: .normal)
    button.tintColor = .white
    
    return button
  }()
  private let imageName: String
  
  
  // MARK: - Initializer
  
  init(imageName: String, handler: @escaping () -> Void) {
    self.handler = handler
    self.imageName = imageName
    
    super.init()
    
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("This class should be initialized with code")
  }
  
  
  // MARK: - Method
  
  func setColor(to color: UIColor) {
    button.tintColor = color
  }
}

// MARK: - Extension Configure Method

private extension CustomBarButtonItem {
  
  func configure() {
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    
    NSLayoutConstraint.activate([
      button.widthAnchor.constraint(equalToConstant: 30),
      button.heightAnchor.constraint(equalTo: button.widthAnchor)
    ])
    
    customView = button
  }
  
  @objc func buttonTapped() {
    handler()
  }
}
