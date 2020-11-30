//
//  BoardDetailFooter.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/30.
//

import UIKit

final class BoardDetailFooterView: UICollectionReusableView, Reusable {
  
  // MARK: - Property
  
  private lazy var button: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    
    return button
  }()
  
  private lazy var titleInputView: CustomTextField = {
    let view = CustomTextField()
    view.delegate = self
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  var addHandler: ((String) -> Void)?
  
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
    addSubview(button)
    addSubview(titleInputView)

    configureButton()
    configureTitleInputView()
  }
  
  func configureButton() {
    button.layer.masksToBounds = true
    button.layer.cornerRadius = 10
    
    button.setTitle("리스트 추가", for: .normal)
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    
    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: centerXAnchor),
      button.topAnchor.constraint(equalTo: topAnchor, constant: 20),
      button.widthAnchor.constraint(equalToConstant: bounds.width * 0.9),
      button.heightAnchor.constraint(equalToConstant: 40)
    ])
    button.layoutIfNeeded()
    
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark))
    blur.frame = button.bounds
    blur.isUserInteractionEnabled = false
    button.insertSubview(blur, at: 0)
  }
  
  func configureTitleInputView() {
    NSLayoutConstraint.activate([
      titleInputView.topAnchor.constraint(equalTo: button.topAnchor),
      titleInputView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
      titleInputView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
      titleInputView.heightAnchor.constraint(equalToConstant: button.frame.height * 2)
    ])
    
    titleInputView.alpha = 0
  }
  
  @objc private func buttonTapped() {
    
    UIView.transition(
      with: titleInputView,
      duration: 0.3,
      options: .transitionCurlDown ,
      animations: {
        self.titleInputView.alpha = 1
      }, completion: nil)
  }
}

extension BoardDetailFooterView: CustomTextFieldDelegate {
  
  func addButtonTapped(text: String) {
    addHandler?(text)
    closeButtonTapped()
  }
  
  func closeButtonTapped() {
    self.titleInputView.alpha = 0
    
    UIView.transition(
      with: titleInputView,
      duration: 0.3,
      options: .transitionCurlUp ,
      animations: nil,
      completion: nil)
  }
}
