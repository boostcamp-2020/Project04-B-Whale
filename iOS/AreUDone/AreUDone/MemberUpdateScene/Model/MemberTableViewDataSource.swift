//
//  MemberTableViewDataSource.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/07.
//

import UIKit

class MemberTableViewDiffableDataSource: UITableViewDiffableDataSource<MemberSection, User> {
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return MemberSection.invited.description
    case 1:
      return MemberSection.notInvited.description
      
    default:
      return "none"
    }
  }
}
