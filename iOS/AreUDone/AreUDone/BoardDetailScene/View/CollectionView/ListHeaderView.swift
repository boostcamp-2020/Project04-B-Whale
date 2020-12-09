//
//  ListHeaderView.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/29.
//

import UIKit

final class ListHeaderView: UICollectionReusableView, Reusable {
  
  // MARK: - Property
  
  private var viewModel: ListViewModelProtocol!
  
  private lazy var titleTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    textField.returnKeyType = .done
    textField.delegate = self
    textField.font = UIFont.nanumB(size: 18)

    return textField
  }()
  
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    bindUI()
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  
  // MARK: - Method
  
  func update(with viewModel: ListViewModelProtocol) {
    self.viewModel = viewModel
    bindUI()

    titleTextField.text = viewModel.fetchListTitle()
  }
}


// MARK: - Extension Configure Method

private extension ListHeaderView {

  func configure() {
    addSubview(titleTextField)
    
    configureView()
    configureTitleTextField()
  }
  
  func configureView() {
    backgroundColor = #colorLiteral(red: 0.944453299, green: 0.9647708535, blue: 0.9688996673, alpha: 0.745906464)
    layer.cornerRadius = 5
    
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 1)
    layer.shadowRadius = 0.4
    layer.shadowOpacity = 0.3
  }
  
  func configureTitleTextField() {
    NSLayoutConstraint.activate([
      titleTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
      titleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      titleTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 15)
    ])
  }
}

extension ListHeaderView: UITextFieldDelegate {
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if let title = textField.text {
      viewModel.updateListTitle(to: title)
    }
    textField.resignFirstResponder()
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
}

private extension ListHeaderView {
  
  func bindUI() {
    viewModel.bindingUpdateListTitle { [weak self] title in
      DispatchQueue.main.async {
        self?.titleTextField.text = title
      }
    }
  }
}

