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
    backgroundPlay()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    backgroundRemove()
  }
  
  
  // MARK: - Method
  
  @IBAction func naverSigninButtonTapped(_ sender: Any) {
    signinCoordinator?.openURL(endPoint: UserEndPoint.requestLogin(flatform: .naver))
  }
  
  @IBAction func githubSigninButtonTapped(_ sender: Any) {
    
  }
  
  private func backgroundPlay() {
    viewModel.videoPlay()
  }
  
  private func backgroundRemove() {
    viewModel.videoRemove()
  }
}


// MARK: - Extension bindUI

private extension SigninViewController {
  
  private func bindUI() {
    videoPlayBinding()
  }

  func videoPlayBinding() {
    viewModel.videoPlayBinding { [weak self] playerLayer in
      guard let self = self else { return }
      playerLayer.frame = self.videoBackgroundView.bounds
      self.videoBackgroundView.layer.addSublayer(playerLayer)
      
      UIView.animate(withDuration: 1) {
        self.videoBackgroundView.alpha = 1
      }
    }
  }
}

