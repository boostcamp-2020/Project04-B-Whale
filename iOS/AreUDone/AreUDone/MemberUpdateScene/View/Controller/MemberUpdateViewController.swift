//
//  MemberUpdateViewController.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/07.
//

import UIKit

final class MemberUpdateViewController: UIViewController {
  
  // MARK:- Property
  
  private let viewModel: MemberUpdateViewModelProtocol
  
  
  // MARK:- Initializer
  
  init?(coder: NSCoder, viewModel: MemberUpdateViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("this controller should be initialized with code")
  }
  
  
  // MARK:- Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}
