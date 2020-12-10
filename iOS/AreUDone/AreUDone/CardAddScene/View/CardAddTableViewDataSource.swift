//
//  CardAddDataSource.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/10.
//

import UIKit

final class CardAddTableViewDataSource: NSObject, UITableViewDataSource {
  
  // MARK: - Property
  
  private let viewModel: CardAddViewModelProtocol
  
  
  // MARK: - Initializer
  
  init(viewModel: CardAddViewModelProtocol) {
    self.viewModel = viewModel
  }
  
  
  // MARK: - Method
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch indexPath.row {
    case 0:
      let cell: TitleTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
      cell.delegate = self
      
      return cell
//
//    case 1:
//      let cell: BoardColorTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
//      cell.delegate = self
//      return cell
//
    default:
      return UITableViewCell()
    }
  }
}


// MARK: - Extension BoardTitleTableViewCell Delegate

extension CardAddTableViewDataSource: TitleTableViewCellDelegate {
  
  func textFieldDidChanged(with title: String) {
  }
}


// MARK: - Extension      Delegate

extension CardAddTableViewDataSource {
}


