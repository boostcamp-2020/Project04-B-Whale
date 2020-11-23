//
//  CardTableViewCell.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/23.
//

import UIKit

final class CardTableViewCell: UITableViewCell, Reusable, NibLoadable {
  
  // MARK: - Property
  
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var dueDateLabel: UILabel!
  @IBOutlet private weak var commentImageView: UIImageView!
  @IBOutlet private weak var commentCountLabel: UILabel!
  
  
  // MARK: - Initializer
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    configure()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    titleLabel.text = nil
    dueDateLabel.text = nil
    commentCountLabel.text = nil
  }
}


extension CardTableViewCell {
  func update(with card: Card) {
    titleLabel.text = card.title
    dueDateLabel.text = card.dueDate
    commentCountLabel.text = "\(card.commentCount)"
  }
}

// MARK: - Extension

private extension CardTableViewCell {
  
  // MARK:- Method
  
  func configure() {
    configureCardTableViewCell()
    configureTitleLabel()
    configureDueDateLabel()
    configureCommentImageView()
    configureCommentCountLabel()
  }
  
  func configureCardTableViewCell() {
    layer.cornerRadius = 10
    backgroundColor = .systemGray5
    selectionStyle = .none
  }
  
  func configureTitleLabel() {
    titleLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 22)
  }
  
  func configureDueDateLabel() {
    dueDateLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 14)
  }
  
  func configureCommentImageView() {
    let commentImage = UIImage(systemName: "text.bubble")
    commentImageView.image = commentImage
  }
  
  func configureCommentCountLabel() {
    commentCountLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 14)
  }
}
