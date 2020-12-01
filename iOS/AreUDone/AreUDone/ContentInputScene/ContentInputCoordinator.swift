//
//  ContentInputCoordinator.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/01.
//

import UIKit

final class ContentInputCoordinator: Coordinator {
  
  // MARK:- Property
  
  private var storyboard: UIStoryboard {
    return UIStoryboard.load(storyboard: .contentInput)
  }
  
  private let content: String
  
  // MARK:- Initializer
  
  init(content: String) {
    self.content = content
  }
  
  
  // MARK:- Method
  
  func start() -> UIViewController {
    guard let contentInputViewController = storyboard.instantiateViewController(
            identifier: ContentInputViewController.identifier,
            creator: { [weak self] coder in
              guard let self = self else { return UIViewController() }
              
              let viewModel = ContentInputViewModel(content: self.content)
              
              return ContentInputViewController(
                coder: coder,
                viewModel: viewModel
              )
            }) as? ContentInputViewController
    else { return UIViewController() }
    
    contentInputViewController.contentInputCoordinator = self
    
    return contentInputViewController
  }
}
