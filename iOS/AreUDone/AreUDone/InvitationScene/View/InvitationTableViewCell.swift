//
//  InvitationCollectionViewCell.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/05.
//

import UIKit

final class InvitationTableViewCell: UITableViewCell, Reusable {

  // MARK: - Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configure()
  }
}


// MARK: - Extension Configure Method

private extension InvitationTableViewCell {
  
  func configure() {
    accessoryView = UIImageView(image: UIImage(systemName: "plus.circle"))
  }
}
