//
//  ViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/18.
//

import UIKit

class SignInViewController: UIViewController {
  
  private let viewModel: SignInViewModelProtocol
  
  init?(coder: NSCoder, viewModel: SignInViewModelProtocol) {
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

