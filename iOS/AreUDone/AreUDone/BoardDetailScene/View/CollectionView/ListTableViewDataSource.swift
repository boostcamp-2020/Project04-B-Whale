//
//  ListCollectionViewDataSource.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/08.
//

import UIKit


final class ListTableViewDataSource: NSObject, UITableViewDataSource {

  // MARK: - Property

  private let viewModel: ListViewModelProtocol
  private var reset: Bool = true

  // MARK: - Initializer

  init(viewModel: ListViewModelProtocol) {
    self.viewModel = viewModel

    super.init()
  }


  // MARK: - Method
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if reset {
      reset = !reset
      return 0
    }
    return viewModel.numberOfCards()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: ListTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
    cell.update(with: viewModel.fetchCard(at: indexPath.row))
    
    return cell
  }
}
