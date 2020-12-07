//
//  MemberUpdateViewController.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/07.
//

import UIKit

enum MemberSection: CaseIterable {
  case invited
  case notInvited
  
  var description: String {
    switch self {
    case .invited:
      return "카드를 즐겨찾는 멤버"
    case .notInvited:
      return "카드를 즐겨찾지 않는 멤버"
    }
  }
}

final class MemberUpdateViewController: UIViewController {
  
  typealias DataSource = MemberTableViewDiffableDataSource
  typealias Snapshot = NSDiffableDataSourceSnapshot<MemberSection, InvitedUser>
  
  // MARK:- Property
  
  private let viewModel: MemberUpdateViewModelProtocol
  weak var coordinator: MemberUpdateCoordinator?
  
  private lazy var dataSource = configureDataSource()
  
  private lazy var memberTableView: MemberTableView = {
    let tableView = MemberTableView(
      frame: CGRect.zero,
      style: .insetGrouped
    )
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    return tableView
  }()
  
  
  // MARK:- Initializer
  
  init?(coder: NSCoder, viewModel: MemberUpdateViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("this controller should be initialized with code")
  }
  
  
  // MARK:- Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configure()
    applySnapshot(animatingDifferences: false)
  }
}



private extension MemberUpdateViewController {
  
  func configure() {
    memberTableView.delegate = self
    view.addSubview(memberTableView)
    
    configureView()
    configureMemberTableView()
  }
  
  func configureView(){
    navigationItem.title = "멤버"
    
    let barButtonItem = CustomBarButtonItem(imageName: "xmark") { [weak self] in
      self?.coordinator?.dismiss()
    }
    barButtonItem.setColor(to: .black)
    navigationItem.leftBarButtonItem = barButtonItem
  }
  
  func configureMemberTableView() {
    NSLayoutConstraint.activate([
      memberTableView.topAnchor.constraint(equalTo: view.topAnchor),
      memberTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      memberTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      memberTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
}


private extension MemberUpdateViewController {
  
  func configureDataSource() -> DataSource {
    let dataSource = DataSource(
      tableView: memberTableView
    ) { [weak self] (tableView, indexPath, member) -> UITableViewCell? in
      let cell: MemberTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
      
      cell.update(with: member.name)
      
      self?.viewModel.fetchProfileImage(with: member.profileImageUrl, completionHandler: { data in
        let image = UIImage(data: data)
        cell.update(with: image)
      })
      
      return cell
    }
    
    return dataSource
  }
  
  func applySnapshot(animatingDifferences: Bool) {
    var snapshot = Snapshot()
    snapshot.appendSections(MemberSection.allCases)

    viewModel.fetchMemberData { [weak self] (boardMember, cardMember) in
      if let cardMember = cardMember {
        snapshot.appendItems(cardMember, toSection: .invited)
      }
      snapshot.appendItems(boardMember, toSection: .notInvited)
      
      DispatchQueue.main.async {
        self?.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
      }
    }
  }
}


extension MemberUpdateViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
}
