//
//  CardCollectionViewCell.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/24.
//

import UIKit

protocol CardCellDelegate {
  func delete(cardCell: CardCollectionViewCell)
}

class CardCollectionViewCell: UICollectionViewCell, Reusable {
  
  // MARK:- Property
  
  private lazy var scrollView: UIScrollView = {
    let view = UIScrollView()
    view.isPagingEnabled = true
    view.showsVerticalScrollIndicator = false
    view.showsHorizontalScrollIndicator = false
    view.layer.cornerRadius = 10
    view.backgroundColor = .systemRed
    
    return view
  }()
  
  private lazy var stackView: UIStackView = {
    let view = UIStackView()
    view.axis = .horizontal
    view.distribution = .fill
    
    return view
  }()
  
  private lazy var cardContentView: CardContentView = {
    let view = CardContentView()
    
    return view
  }()
  
  private lazy var deleteCardView: DeleteCardView = {
    let view = DeleteCardView()
    
    return view
  }()
  
  var delegate: CardCellDelegate?
  
  // MARK:- Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  
  // MARK:- Method
  
  func updateCell(with card: Card) {
    cardContentView.updateContentView(with: card)
  }
}


// MARK:- Extension

private extension CardCollectionViewCell {
  func configure() {
    backgroundColor = .clear
    configureScrollView()
    configureStackView()
    configureCardContentView()
    configureDeleteCardView()
  }
  
  func configureScrollView() {
    addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.delegate = self
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }
  
  func configureStackView() {
    scrollView.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    if let superViewOfStackView = stackView.superview {
      NSLayoutConstraint.activate([
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        stackView.topAnchor.constraint(equalTo: superViewOfStackView.topAnchor),
        stackView.bottomAnchor.constraint(equalTo: superViewOfStackView.bottomAnchor),
        stackView.leadingAnchor.constraint(equalTo: superViewOfStackView.leadingAnchor),
        stackView.trailingAnchor.constraint(equalTo: superViewOfStackView.trailingAnchor),
      ])
    }
  }
  
  func configureCardContentView() {
    stackView.addArrangedSubview(cardContentView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      cardContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
    ])
  }
  
  func configureDeleteCardView() {
    stackView.addArrangedSubview(deleteCardView)
    deleteCardView.translatesAutoresizingMaskIntoConstraints = false
    let deleteCardViewTapRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(deleteCardViewTapped)
    )
    deleteCardView.addGestureRecognizer(deleteCardViewTapRecognizer)
    
    NSLayoutConstraint.activate([
      deleteCardView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
      deleteCardView.widthAnchor.constraint(equalTo: deleteCardView.heightAnchor),
    ])
  }
}


// MARK:- Extension obj-c

extension CardCollectionViewCell {
  
  @objc private func deleteCardViewTapped() {
    delegate?.delete(cardCell: self)
  }
}

// MARK:- Extension

extension CardCollectionViewCell: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollView.backgroundColor = scrollView.contentOffset.x <= 0 ? .clear : .systemRed
  }
}
