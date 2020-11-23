//
//  SigninViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/18.
//

import UIKit

final class SigninViewController: UIViewController {
  
  // MARK: - Property
  
  private let viewModel: SigninViewModelProtocol
  weak var signinCoordinator: SigninCoordinator?
  
  @IBOutlet private weak var videoBackgroundView: UIView! {
    didSet {
      videoBackgroundView.alpha = 0
    }
  }
  
  // MARK: - Initializer
  
  init?(coder: NSCoder, viewModel: SigninViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("This controller must be initialized with code")
  }
  
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindUI()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    backgroundRemove()
  }
  
  
  // MARK: - Method
  
  @IBAction func appleSigninButtonTapped(_ sender: Any) {
    viewModel.appleSigninButtonTapped()
  }
  
  @IBAction func naverSigninButtonTapped(_ sender: Any) {
    viewModel.naverSigninButtonTapped()
  }
}


// MARK: - Extension

extension SigninViewController {
  
  private func bindUI() {
    appleSigninBinding()
    naverSigninBinding()
    videoPlayBinding()
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

  private func videoPlayBinding() {
    viewModel.videoPlayBinding { [weak self] playerLayer in
      guard let self = self else { return }
      playerLayer.frame = self.videoBackgroundView.bounds
      self.videoBackgroundView.layer.addSublayer(playerLayer)
      
      UIView.animate(withDuration: 1) {
        self.videoBackgroundView.alpha = 1
      }
    }
  }
  
  private func backgroundPlay() {
    viewModel.videoPlay()
  }
  
  private func backgroundRemove() {
    viewModel.videoRemove()
  }
}

