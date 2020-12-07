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
  typealias Snapshot = NSDiffableDataSourceSnapshot<MemberSection, CardDetail.Member>
  
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
    applySnapshot(with: nil, animatingDifferences: false)
  }
}



private extension MemberUpdateViewController {
  
  func configure() {
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
    ) { (tableView, indexPath, member) -> UITableViewCell? in
      let cell: MemberTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
      
      cell.update(with: member.name)
      
      return cell
    }
    
    return dataSource
  }
  
  func applySnapshot(with members: [CardDetail.Member]?, animatingDifferences: Bool) {
    var snapshot = Snapshot()
    
    snapshot.appendSections(MemberSection.allCases)
    let mem1 = CardDetail.Member(id: 0, name: "서명렬", profileImageUrl: "")
    let mem2 = CardDetail.Member(id: 1, name: "심영민", profileImageUrl: "")
    snapshot.appendItems([mem1], toSection: .invited)
    snapshot.appendItems([mem2], toSection: .notInvited)
    
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }
}
