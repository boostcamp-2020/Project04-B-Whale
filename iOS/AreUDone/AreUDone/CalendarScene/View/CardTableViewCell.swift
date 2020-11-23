//
//  CardTableViewCell.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/23.
//

import UIKit

final class CardTableViewCell: UITableViewCell, Reusable, NibLoadable {
  
  // MARK: - Property
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dueDateLabel: UILabel!
  @IBOutlet weak var commentImageView: UIImageView!
  @IBOutlet weak var commentCountLabel: UILabel!
  
  
  // MARK: - Initializer
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    configure()
  }
}


// MARK: - Extension

extension CardTableViewCell {
  
  private func configure() {
    configureTitleLabel()
    configureDueDateLabel()
    configureCommentImageView()
    configureCommentCountLabel()
  }
  
  private func configureCardTableViewCell() {
    layer.cornerRadius = 10
  }
  
  private func configureTitleLabel() {
    titleLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 22)
  }
  
  private func configureDueDateLabel() {
    dueDateLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 14)
  }
  
  private func configureCommentImageView() {
    let commentImage = UIImage(systemName: "text.bubble")
    commentImageView.image = commentImage
  }
  
  private func configureCommentCountLabel() {
    commentCountLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 14)
  }
}
