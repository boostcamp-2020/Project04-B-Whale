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
}


// MARK: - Extension

private extension CardTableViewCell {
  
  // MARK:- Method
  
  func configure() {
    configureTitleLabel()
    configureDueDateLabel()
    configureCommentImageView()
    configureCommentCountLabel()
  }
  
  func configureCardTableViewCell() {
    layer.cornerRadius = 10
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
