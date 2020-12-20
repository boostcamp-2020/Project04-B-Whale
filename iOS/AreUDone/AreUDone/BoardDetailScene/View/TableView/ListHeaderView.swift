//
//  ListHeaderView.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/29.
//

import UIKit

final class ListHeaderView: UIView {

  // MARK: - Property

  private var viewModel: ListViewModelProtocol!

  private lazy var baseView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    view.backgroundColor = UIColor.clear
    
    return view
  }()
  private lazy var titleTextField: PaddingTextField = {
    let textField = PaddingTextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.delegate = self

    textField.returnKeyType = .done
    textField.font = UIFont.nanumB(size: 18)
    
    textField.backgroundColor = #colorLiteral(red: 0.944453299, green: 0.9647708535, blue: 0.9688996673, alpha: 0.745906464)
    textField.layer.cornerRadius = 5

    textField.addShadow(
      offset: CGSize(width: 0, height: 1),
      radius: 0.4,
      opacity: 0.3
    )

    return textField
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

  func update(with viewModel: ListViewModelProtocol) {
    self.viewModel = viewModel
    bindUI()

    titleTextField.text = viewModel.fetchListTitle()
  }
}


// MARK: - Extension Configure Method

private extension ListHeaderView {

  func configure() {
    addSubview(baseView)
    baseView.addSubview(titleTextField)

    configureBaseView()
    configureTitleTextField()
  }

  func configureBaseView() {
    NSLayoutConstraint.activate([
      baseView.topAnchor.constraint(equalTo: topAnchor),
      baseView.leadingAnchor.constraint(equalTo: leadingAnchor),
      baseView.trailingAnchor.constraint(equalTo: trailingAnchor),
      baseView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  func configureTitleTextField() {
    NSLayoutConstraint.activate([
      titleTextField.centerYAnchor.constraint(equalTo: baseView.centerYAnchor),
      titleTextField.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
      titleTextField.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
      titleTextField.heightAnchor.constraint(equalTo: baseView.heightAnchor, multiplier: 0.7)
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

