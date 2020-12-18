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
      let cell: TitleTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
      cell.delegate = self
      
      cell.update(
        withTitle: "보드 제목",
        placeholder: "보드 제목을 입력해주세요"
      )
      
      return cell
      
    case 1:
      let cell: BoardColorTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
      cell.delegate = self
      
      viewModel.updateRGBHexString { hexString in
        cell.update(with: hexString)
      }
      
      return cell
      
    default:
      return UITableViewCell()
    }
  }
}


// MARK: - Extension BoardTitleTableViewCell Delegate

extension BoardAddTableViewDataSource: TitleTableViewCellDelegate {
  
  func textFieldDidChanged(to title: String) {
    viewModel.updateBoardTitle(to: title)
  }
}


// MARK: - Extension BoardColorTableViewCell Delegate

extension BoardAddTableViewDataSource: BoardColorTableViewCellDelegate {
  
  func randomButtonTapped() {
    viewModel.updateRGBHexString()
  }
}

