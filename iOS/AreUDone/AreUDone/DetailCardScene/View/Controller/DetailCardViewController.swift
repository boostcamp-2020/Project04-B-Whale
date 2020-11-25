//
//  DetailCardViewController.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/25.
//

import UIKit

final class DetailCardViewController: UIViewController {
  
  // MARK:- Property
  
  private let viewModel: DetailCardViewModelProtocol
  
  // MARK:- Initializer
  
  init?(coder: NSCoder, viewModel: DetailCardViewModelProtocol) {
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
