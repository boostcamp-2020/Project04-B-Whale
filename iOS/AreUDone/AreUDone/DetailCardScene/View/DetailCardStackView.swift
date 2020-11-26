//
//  DetailCardStackView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/26.
//

import UIKit

final class DetailCardStackView: UIStackView {
  
  // MARK:- Property
  
  private lazy var detailCardContentView: DetailCardContentView = {
    let view = DetailCardContentView()
    
    return view
  }()
  
  private lazy var detailCardDueDateView: DetailCardDueDateView = {
    let view = DetailCardDueDateView()
    
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
    detailCardContentView.update(content: content)
  }
  
  func updateDueDateView(with dueDate: String) {
    detailCardDueDateView.update(dueDate: dueDate)
  }
}


// MARK:- Extension Configure Method

private extension DetailCardStackView {
  
  func configure() {
    axis = .vertical
    distribution = .fill
//    backgroundColor = .blue
    spacing = 10
    
    addArrangedSubview(detailCardContentView)
    addArrangedSubview(detailCardDueDateView)
    
    configureDetailCardContentView()
    configureDetailCardDueDateView()
  }
  
  func configureDetailCardContentView() {
    detailCardContentView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      detailCardContentView.widthAnchor.constraint(equalTo: widthAnchor)
    ])
  }
  
  func configureDetailCardDueDateView() {
    detailCardDueDateView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      detailCardDueDateView.widthAnchor.constraint(equalTo: widthAnchor)
    ])
  }
}
