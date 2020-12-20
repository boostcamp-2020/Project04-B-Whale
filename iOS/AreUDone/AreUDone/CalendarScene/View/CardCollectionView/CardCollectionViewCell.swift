//
//  CardCollectionViewCell.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/24.
//

import UIKit

protocol CardCellDelegate: AnyObject {
  
  func remove(cell: CardCollectionViewCell)
  func resetCellOffset(without cell: CardCollectionViewCell)
  func didSelect(for cell: CardCollectionViewCell)
}

final class CardCollectionViewCell: UICollectionViewCell, Reusable {
  
  // MARK:- Property
  
  private lazy var scrollView: UIScrollView = {
    let view = UIScrollView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isPagingEnabled = true
    view.showsVerticalScrollIndicator = false
    view.showsHorizontalScrollIndicator = false
    view.layer.cornerRadius = 6
    view.backgroundColor = .clear
    view.bounces = false
    view.delegate = self
    
    return view
  }()
  private lazy var stackView: UIStackView = {
    let view = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .horizontal
    view.distribution = .fill
    
    return view
  }()
  private lazy var cardContentView: CardContentView = {
    let view = CardContentView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  private lazy var deleteCardView: DeleteCardView = {
    let view = DeleteCardView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  weak var delegate: CardCellDelegate?
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
    addSubview(scrollView)
    scrollView.addSubview(stackView)
    stackView.addArrangedSubview(cardContentView)
    stackView.addArrangedSubview(deleteCardView)
    
    configureScrollView()
    configureStackView()
    configureCardContentView()
    configureDeleteCardView()
    addingGestureRecognizer()
  }
  
  func configureView() {
    backgroundColor = .clear
  }
  
  func configureScrollView() {
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }
  
  func configureStackView() {
    NSLayoutConstraint.activate([
      stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
    ])
  }
  
  func configureCardContentView() {
    NSLayoutConstraint.activate([
      cardContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
    ])
  }
  
  func configureDeleteCardView() {
    NSLayoutConstraint.activate([
      deleteCardView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
      deleteCardView.widthAnchor.constraint(equalTo: deleteCardView.heightAnchor),
    ])
  }
  
  func addingGestureRecognizer() {
    let cardContentViewTapRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(cardContentViewTapped))
    cardContentView.addGestureRecognizer(cardContentViewTapRecognizer)
    
    let deleteCardViewTapRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(deleteCardViewTapped)
    )
    deleteCardView.addGestureRecognizer(deleteCardViewTapRecognizer)
  }
}


// MARK:- Extension objc Method

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
