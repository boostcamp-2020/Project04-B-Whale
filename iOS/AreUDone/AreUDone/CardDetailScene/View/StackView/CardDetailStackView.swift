//
//  CardDetailStackView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/26.
//

import UIKit

final class CardDetailStackView: UIStackView {
  
  // MARK:- Property
  
  private lazy var cardDetailLocationView: CardDetailLocationView = {
    let view = CardDetailLocationView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  private lazy var cardDetailContentView: CardDetailContentView = {
    let view = CardDetailContentView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  private lazy var cardDetailDueDateView: CardDetailDueDateView = {
    let view = CardDetailDueDateView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  
  // MARK:- Initializer
  
  required init(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  
  // MARK:- Method
  
  func updateListOfLocationView(with title: String) {
    cardDetailLocationView.updateListNameLabel(with: title)
  }
  
  func updateBoardOfLocationView(with title: String) {
    cardDetailLocationView.updateBoardNameLabel(with: title)
  }
  
  func updateContentView(with content: String) {
    cardDetailContentView.update(content: content)
  }
  
  func updateDueDateView(with dueDate: String) {
    cardDetailDueDateView.update(dueDate: dueDate)
  }
  
  func setupContentViewDelegate<T: UIViewController>(_ delegate: T) where T: CardDetailContentViewDelegate {
    cardDetailContentView.delegate = delegate.self
  }
  
  func setupDueDateViewDelegate<T: UIViewController>(_ delegate: T) where T: CardDetailDueDateViewDelegate {
    cardDetailDueDateView.delegate = delegate.self
  }
}


// MARK:- Extension Configure Method

private extension CardDetailStackView {
  
  func configure() {
    axis = .vertical
    distribution = .fill
    spacing = 20
    
    addArrangedSubview(cardDetailLocationView)
    addArrangedSubview(cardDetailContentView)
    addArrangedSubview(cardDetailDueDateView)
    
    configureCardDetailLocationView()
    configureCardDetailContentView()
    configureCardDetailDueDateView()
  }
  
  func configureCardDetailLocationView() {
    NSLayoutConstraint.activate([
      cardDetailLocationView.widthAnchor.constraint(equalTo: widthAnchor)
    ])
  }
  
  func configureCardDetailContentView() {
    NSLayoutConstraint.activate([
      cardDetailContentView.widthAnchor.constraint(equalTo: widthAnchor)
    ])
  }
  
  func configureCardDetailDueDateView() {
    NSLayoutConstraint.activate([
      cardDetailDueDateView.widthAnchor.constraint(equalTo: widthAnchor)
    ])
  }
}
