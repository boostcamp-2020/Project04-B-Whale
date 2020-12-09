//
//  BoardAddTableViewDataSoruce.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/07.
//

import UIKit

final class BoardAddTableViewDataSource: NSObject, UITableViewDataSource {
  
  // MARK: - Property
  
  private let viewModel: BoardAddViewModelProtocol
  
  
  // MARK: - Initializer
  
  init(viewModel: BoardAddViewModelProtocol) {
    self.viewModel = viewModel
  }
  
  
  // MARK: - Method
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch indexPath.row {
    case 0:
      let cell: BoardTitleTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
      cell.delegate = self
      
      return cell
      
    case 1:
      let cell: BoardColorTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
      cell.delegate = self
      return cell
      
    default:
      return UITableViewCell()
    }
  }
}


// MARK: - Extension BoardTitleTableViewCell Delegate

extension BoardAddTableViewDataSource: BoardTitleTableViewCellDelegate {
  
  func textFieldDidChanged(with title: String) {
    viewModel.updateBoardTitle(with: title)
  }
}


// MARK: - Extension BoardColorTableViewCell Delegate

extension BoardAddTableViewDataSource: BoardColorTableViewCellDelegate {
  
  func randomButtonTapped(cell: BoardColorTableViewCell) {
    viewModel.updateRGBHexString()
  }
}
