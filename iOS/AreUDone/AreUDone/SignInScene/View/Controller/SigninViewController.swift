//
//  SigninViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/18.
//

import UIKit

final class SigninViewController: UIViewController {
  
  private let viewModel: SigninViewModelProtocol
  
  init?(coder: NSCoder, viewModel: SigninViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("This controller must be initialized with code")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  
}

