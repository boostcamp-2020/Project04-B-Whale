//
//  CardDetailStackView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/26.
//

import UIKit

final class CardDetailStackView: UIStackView {
  
  // MARK:- Property
  
  private lazy var cardDetailContentView: CardDetailContentView = {
    let view = CardDetailContentView()
    
    return view
  }()
  
  private lazy var cardDetailDueDateView: CardDetailDueDateView = {
    let view = CardDetailDueDateView()
    
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
  
  func updateContentView(with content: String) {
    cardDetailContentView.update(content: content)
  }
  
  func updateDueDateView(with dueDate: String) {
    cardDetailDueDateView.update(dueDate: dueDate)
  }
}


// MARK:- Extension Configure Method

private extension CardDetailStackView {
  
  func configure() {
    axis = .vertical
    distribution = .fill
//    backgroundColor = .blue
    spacing = 10
    
    addArrangedSubview(cardDetailContentView)
    addArrangedSubview(cardDetailDueDateView)
    
    configureCardDetailContentView()
    configureCardDetailDueDateView()
  }
  
  func configureCardDetailContentView() {
    cardDetailContentView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      cardDetailContentView.widthAnchor.constraint(equalTo: widthAnchor)
    ])
  }
  
  func configureCardDetailDueDateView() {
    cardDetailDueDateView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      cardDetailDueDateView.widthAnchor.constraint(equalTo: widthAnchor)
    ])
  }
}
