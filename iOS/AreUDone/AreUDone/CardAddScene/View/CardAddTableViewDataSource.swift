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
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch indexPath.row {
    case 0:
      let cell: TitleTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
      cell.delegate = self
      
      cell.update(
        withTitle: "카드 제목",
        placeholder: "카드 제목을 입력해주세요"
      )
      
      return cell

    case 1:
      let cell: CardAddCalendarTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
      
      viewModel.fetchDate { dateString in
        cell.update(with: dateString)
      }
    
      return cell
      
    case 2:
      let cell: CardAddContentsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)

      viewModel.fetchContent { content in
        cell.update(withContent: content)
      }
      
      return cell
      
    default:
      return UITableViewCell()
    }
  }
}


// MARK: - Extension BoardTitleTableViewCell Delegate

extension CardAddTableViewDataSource: TitleTableViewCellDelegate {
  
  func textFieldDidChanged(to title: String) {
    viewModel.updateListTitle(to: title)
  }
}


