//
//  CardAddViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/10.
//

import UIKit

final class CardAddViewController: UIViewController {
  
  // MARK: - Property
  
  weak var coordinator: CardAddCoordinator?
  private let viewModel: CardAddViewModelProtocol

  @IBOutlet private weak var tableView: CardAddTableView! {
    didSet {
      tableView.dataSource = dataSource
      tableView.delegate = self
    }
  }
  
  private var rightBarButtonItem: UIBarButtonItem!
  private lazy var dataSource = CardAddTableViewDataSource(viewModel: viewModel)
  
  
  // MARK: - Initializer
  
  init?(coder: NSCoder, viewModel: CardAddViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("This class should be initialized with code")
  }
  
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindUI()
    configure()
  }
}


// MARK: - Extension Configure Method

private extension CardAddViewController {
  
  func configure() {
    configureView()
  }
  
  func configureView() {
    navigationItem.title = "카드 추가"
    navigationController?.navigationBar.titleTextAttributes = [
      NSAttributedString.Key.font: UIFont.nanumB(size: 20)
    ]

    let leftBarButtonItem = CustomBarButtonItem(imageName: "xmark") { [weak self] in
      self?.coordinator?.dismiss()
    }
    leftBarButtonItem.setColor(to: .black)
    
    rightBarButtonItem = UIBarButtonItem(
      title: "생성하기",
      style: .plain,
      target: self,
      action: #selector(createButtonTapped)
    )
    rightBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.nanumR(size: 18)], for: .normal)
    rightBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.nanumR(size: 18)], for: .disabled)
    rightBarButtonItem.isEnabled = false
    
    navigationItem.leftBarButtonItem = leftBarButtonItem
    navigationItem.rightBarButtonItem = rightBarButtonItem
  }
  
  @objc func createButtonTapped() {
    viewModel.createCard()
  }
}


// MARK: - Extension UITableView Delegate

extension CardAddViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case 1:
      viewModel.presentCalendar()
      
    case 2:
      viewModel.pushContentInput()
      
    default:
      break
    }
  }
}


// MARK: - Extension CalendarPickerViewController Delegate

extension CardAddViewController: CalendarPickerViewControllerDelegate {
  
  func send(selectedDate: String) {
    viewModel.updateSelectedDate(to: selectedDate)
  }
}


// MARK: - Extension ContentInputViewController Delegate

extension CardAddViewController: ContentInputViewControllerDelegate {
  
  func send(with content: String) {
    viewModel.updateContent(to: content)
  }
}


// MARK: - Extension bindUI

extension CardAddViewController {
  
  func bindUI() {
    viewModel.bindingIsCreateEnable { [weak self] bool in
      self?.rightBarButtonItem.isEnabled = bool
    }
    
    viewModel.bindingPresentCalendar() { [weak self] dateString in
      guard let self = self else { return }
      
      self.coordinator?.presentCalendar(with: dateString, delegate: self)
    }
    
    viewModel.bindingPushContentInput { [weak self] contents in
      guard let self = self else { return }
      
      self.coordinator?.pushContentInput(with: contents, delegate: self)
    }
    
    viewModel.bindingUpdateTableView() { [weak self] in
      self?.tableView.reloadData()
    }
    
    viewModel.bindingPop() { [weak self] in
      DispatchQueue.main.async {
        self?.coordinator?.dismiss()
      }
    }
  }
}
