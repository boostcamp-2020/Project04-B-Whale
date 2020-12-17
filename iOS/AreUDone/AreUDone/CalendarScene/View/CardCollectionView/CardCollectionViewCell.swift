//
//  CardCollectionViewCell.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/24.
//

import UIKit

protocol CardCellDelegate {
  
  func remove(cell: CardCollectionViewCell)
  func resetCellOffset(without cell: CardCollectionViewCell)
  func didSelect(for cell: CardCollectionViewCell)
}

final class CardCollectionViewCell: UICollectionViewCell, Reusable {
  
  // MARK:- Property
  
  private lazy var scrollView: UIScrollView = {
    let view = UIScrollView()
    view.isPagingEnabled = true
    view.showsVerticalScrollIndicator = false
    view.showsHorizontalScrollIndicator = false
    view.layer.cornerRadius = 6
    view.backgroundColor = .clear
    view.bounces = false
    
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
  var isSwiped: Bool = false
  
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
  
  func resetOffset() {
    UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
      self.scrollView.contentOffset.x = 0
    }.startAnimation()
  }
}


// MARK:- Extension Configure Method

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
    
    NSLayoutConstraint.activate([
      stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
    ])
  }
  
  func configureCardContentView() {
    stackView.addArrangedSubview(cardContentView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    let tapRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(cardContentViewTapped))
    cardContentView.addGestureRecognizer(tapRecognizer)
    
    
    NSLayoutConstraint.activate([
      cardContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
    ])
  }
  
  func configureDeleteCardView() {
    stackView.addArrangedSubview(deleteCardView)
    deleteCardView.translatesAutoresizingMaskIntoConstraints = false
    let tapRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(deleteCardViewTapped)
    )
    deleteCardView.addGestureRecognizer(tapRecognizer)
    
    NSLayoutConstraint.activate([
      deleteCardView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
      deleteCardView.widthAnchor.constraint(equalTo: deleteCardView.heightAnchor),
    ])
  }
}


// MARK:- Extension obj-c

extension CardCollectionViewCell {
  
  @objc private func deleteCardViewTapped() {
    delegate?.remove(cell: self)
  }
  
  @objc private func cardContentViewTapped() {
    delegate?.didSelect(for: self)
  }
}

// MARK:- Extension UIScrollViewDelegate

extension CardCollectionViewCell: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.x <= 0 {
      isSwiped = false
    } else {
      delegate?.resetCellOffset(without: self)
      isSwiped = true
    }
  }
}
