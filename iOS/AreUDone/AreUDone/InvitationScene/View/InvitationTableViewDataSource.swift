//
//  InvitationTableViewDataSource.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/05.
//

import UIKit

final class InvitationTableViewDataSource: NSObject, UITableViewDataSource {
  
  // MARK: - Property
  
  private let viewModel: InvitationViewModelProtocol
  
  
  // MARK: - Initializer
  
  init(viewModel: InvitationViewModelProtocol) {
    self.viewModel = viewModel
  }
  
  
  // MARK: - Method
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // TODO: 데이터가 0개일 경우 backgroundview 로 안내
    return viewModel.numberOfUsers()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: InvitationTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
    
    viewModel.fetchUserInfo(at: indexPath.row) { user, data in
      DispatchQueue.main.async {
        cell.update(with: data, and: user)
      }
    }
    
    return cell
  }
}
