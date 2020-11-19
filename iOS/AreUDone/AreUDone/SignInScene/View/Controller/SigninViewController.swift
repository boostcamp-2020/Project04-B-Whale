//
//  SigninViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/18.
//

import UIKit

final class SigninViewController: UIViewController {
  
  private let viewModel: SigninViewModelProtocol
  weak var signinCoordinator: SigninCoordinator?
  
  init?(coder: NSCoder, viewModel: SigninViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("This controller must be initialized with code")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindUI()
  }
  
  private func bindUI() {
    appleSigninBinding()
    naverSigninBinding()
  }
  
  private func appleSigninBinding() {
    viewModel.appleSigninBinding() { [weak self] endpoint in
      self?.signinCoordinator?.openURL(endPoint: endpoint)
    }
  }
  
  private func naverSigninBinding() {
    viewModel.naverSigninBinding() { [weak self] endpoint in
      self?.signinCoordinator?.openURL(endPoint: endpoint)
    }
  }
  
  @IBAction func appleSigninButtonTapped(_ sender: Any) {
    viewModel.appleSigninButtonTapped()
  }
  
  @IBAction func naverSigninButtonTapped(_ sender: Any) {
    viewModel.naverSigninButtonTapped()
  }
}

