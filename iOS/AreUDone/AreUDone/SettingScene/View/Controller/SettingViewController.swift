//
//  SettingViewController.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/15.
//

import UIKit

final class SettingViewController: UIViewController {
  
  // MARK:- Property
  
  private let viewModel: SettingViewModelProtocol
  weak var coordinator: SettingCoordinator?
  
  private lazy var settingTableView: SettingTableView = {
    let tableView = SettingTableView(frame: CGRect.zero, style: .insetGrouped)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    return tableView
  }()
  
  
  // MARK:- Initializer
  
  init?(coder: NSCoder, viewModel: SettingViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("This controller must be initialized with code")
  }
  
  
  // MARK:- Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configure()
    bindUI()
  }
}


// MARK: - Extension

private extension SettingViewController {
  
  func configure() {
    settingTableView.dataSource = self
    settingTableView.delegate = self
    
    configureView()
    configureSettingTableView()
  }
  
  func configureView() {
    navigationItem.title = "설정"
    
    view.addSubview(settingTableView)
  }
  
  func configureSettingTableView() {
    NSLayoutConstraint.activate([
      settingTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      settingTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      settingTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      settingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
}


// MARK:- Extension BindUI

private extension SettingViewController {
  
  func bindUI() {
    bindingLogout()
  }
  
  func bindingLogout() {
    viewModel.bindingLogoutHandler { [weak self] in
      self?.coordinator?.logout()
    }
  }
}

extension SettingViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: SettingTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
    
    cell.update(with: "로그아웃")
    
    return cell
  }
}

extension SettingViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    switch indexPath.section {
    case 0:
      let alert = UIAlertController(
        alertType: .logout,
        alertStyle: .actionSheet,
        confirmAction: {
          self.viewModel.logout()
        })
      
      present(alert, animated: true)
    
    default:
      break
    }
  }
}
