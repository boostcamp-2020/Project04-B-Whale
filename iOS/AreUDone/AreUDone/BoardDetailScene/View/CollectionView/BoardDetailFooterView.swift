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
    button.layer.masksToBounds = true
    button.layer.cornerRadius = 10
    button.setTitle("리스트 추가", for: .normal)
    button.titleLabel?.font = UIFont.nanumB(size: 18)
    
    return button
  }()
  
  private lazy var titleInputView: AddOrCancelView = {
    let view = AddOrCancelView()
    view.delegate = self
    view.translatesAutoresizingMaskIntoConstraints = false
    
    view.alpha = 0

    return view
  }()
  var listAddHandler: ((String) -> Void)?
  
  
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

private extension BoardDetailFooterView {
  
  func configure() {
    addSubview(button)
    addSubview(titleInputView)

    configureButton()
    configureTitleInputView()
  }
  
  func configureButton() {
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
  }
  
  @objc func buttonTapped() {
    UIView.transition(
      with: titleInputView,
      duration: 0.3,
      options: .transitionCurlDown ,
      animations: {
        self.titleInputView.alpha = 1
      }, completion: nil)
    
    titleInputView.setFirstResponder()
  }
  
}


// MARK: - Extension CustomTextFieldDelegate

extension BoardDetailFooterView: AddOrCancelViewDelegate {
  
  func addButtonTapped(listTitle: String) {
    listAddHandler?(listTitle)
    cancelButtonTapped()
  }
  
  func cancelButtonTapped() {
    self.titleInputView.alpha = 0
    
    UIView.transition(
      with: titleInputView,
      duration: 0.3,
      options: .transitionCurlUp ,
      animations: nil,
      completion: nil)
  }
}
