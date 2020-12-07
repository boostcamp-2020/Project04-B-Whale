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
  weak var coordinator: MemberUpdateCoordinator?
  
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
    
    configure()
  }
}



private extension MemberUpdateViewController {
  
  func configure() {
    configureView()
  }
  
  func configureView(){
    navigationItem.title = "멤버"

    let barButtonItem = CustomBarButtonItem(imageName: "xmark") { [weak self] in
      self?.coordinator?.dismiss()
    }
    barButtonItem.setColor(to: .black)
    navigationItem.leftBarButtonItem = barButtonItem
  }
}
