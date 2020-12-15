//
//  SettingViewController.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/15.
//

import UIKit

final class SettingViewController: UIViewController {
  
  // MARK:- Property
  
  private let viewModel: SettingViewModelProtocol
  
  
  // MARK:- Initializer
  
  init?(coder: NSCoder, viewModel: SettingViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("This controller must be initialized with code")
  }
  
  
  // MARK:- Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}
