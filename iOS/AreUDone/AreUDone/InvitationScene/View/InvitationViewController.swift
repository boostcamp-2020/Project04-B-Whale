//
//  InvitationViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/05.
//

import UIKit

final class InvitationViewController: UIViewController {
  
  // MARK: property
  
  private let viewModel: InvitationViewModelProtocol
  weak var coordinator: InvitationCoordinator?
  
  
  // MARK: - Initializer
  
  init?(coder: NSCoder, viewModel: InvitationViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("This class should be initialized with code")
  }
  
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
}


// MARK: - Extension Configure Method

private extension InvitationViewController {
  
}
