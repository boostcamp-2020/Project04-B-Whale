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
  private var observer: NSKeyValueObservation?
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
    
    configure()
    bindUI()
  }
  
  private func configure() {
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  private func bindUI() {
    observationNavigationBar()
    bindingDetailCardView()
  }
  
  private func observationNavigationBar() {
    observer = navigationController?.navigationBar.observe(
      \.bounds,
      options: [.new, .initial],
      changeHandler: { (navigationBar, changes) in
        if let height = changes.newValue?.height {
          if height > 44.0 {
            //Large Title
          } else {
            //Small Title
          }
        }
      })
  }
  
  private func bindingDetailCardView() {
    
  }
}
