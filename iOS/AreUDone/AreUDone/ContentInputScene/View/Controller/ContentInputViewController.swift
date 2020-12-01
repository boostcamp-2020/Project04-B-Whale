//
//  ContentInputViewController.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/01.
//

import UIKit

final class ContentInputViewController: UIViewController {
  
  // MARK:- Property
  
  private let viewModel: ContentInputViewModelProtocol
  weak var contentInputCoordinator: ContentInputCoordinator?
  
  private lazy var contentTextView: UITextView = {
    let view = UITextView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    view.font = UIFont(name: "AmericanTypewriter", size: 20)
    
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
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(cancelButtonTapped))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: nil)
    
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


private extension ContentInputViewController {
  
  @objc func cancelButtonTapped() {
    navigationController?.popViewController(animated: true)
  }
}
