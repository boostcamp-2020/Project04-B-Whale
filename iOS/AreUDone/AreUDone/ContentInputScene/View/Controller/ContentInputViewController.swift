//
//  ContentInputViewController.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/01.
//

import UIKit

protocol ContentInputViewControllerDelegate {
  
  func send(with content: String)
}


final class ContentInputViewController: UIViewController {
  
  // MARK:- Property
  
  private let viewModel: ContentInputViewModelProtocol
  weak var contentInputCoordinator: ContentInputCoordinator?
  var delegate: ContentInputViewControllerDelegate?
  
  private lazy var contentTextView: UITextView = {
    let view = UITextView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    view.font = UIFont.nanumR(size: 20)
    
    return view
  }()
  
  
  // MARK: - Initializer
  
  init?(coder: NSCoder, viewModel: ContentInputViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("This controller must be initialized with code")
  }
  
  
  // MARK:- Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configure()
    bindUI()
    
    viewModel.initailizeContent()
  }
}


// MARK:- Extension Configure Method

private extension ContentInputViewController {
  
  func configure() {
    view.addSubview(contentTextView)
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      title: "취소",
      style: .done,
      target: self,
      action: #selector(cancelButtonTapped)
    )
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "저장",
      style: .done,
      target: self,
      action: #selector(saveButtonTapped)
    )
    
    configureContentTextView()
  }
  
  func configureContentTextView() {
    NSLayoutConstraint.activate([
      contentTextView.topAnchor.constraint(equalTo: view.topAnchor),
      contentTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
}


// MARK:- Extension BindUI

private extension ContentInputViewController {
  
  func bindUI() {
    bindingInitializeContent()
  }
  
  func bindingInitializeContent() {
    viewModel.bindingInitializeContent { [weak self] content in
      guard !content.isEmpty else { return }
      self?.contentTextView.text = content
    }
  }
}


// MARK:- Extension obj-c

private extension ContentInputViewController {
  
  @objc func cancelButtonTapped() {
    view.endEditing(true)
    let alert = UIAlertController(
      alertType: .dataLoss,
      alertStyle: .actionSheet
    ) { [weak self] in
      self?.contentInputCoordinator?.dismiss()
    }
    cancelAction: { }
    
    present(alert, animated: true, completion: nil)
  }
  
  @objc func saveButtonTapped() {
    guard let content = contentTextView.text else { return }
    view.endEditing(true)
    delegate?.send(with: content)
    contentInputCoordinator?.dismiss()
  }
}
