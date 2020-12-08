//
//  CardDetailMemberViewController.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/07.
//

import UIKit

final class MemberUpdateViewController: UIViewController {
  
  
  private let viewModel: CardDetailViewModelProtocol
  
  init?(coder: NSCoder, viewModel: CardDetailViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("this controller should be initialized with code")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
}
