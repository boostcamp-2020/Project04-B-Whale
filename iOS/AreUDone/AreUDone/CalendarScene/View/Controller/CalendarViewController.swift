//
//  CalendarViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/21.
//

import UIKit

enum Section {
  case main
}

final class CalendarViewController: UIViewController {
  
  typealias DataSource = UITableViewDiffableDataSource<String, Card>
  typealias Snapshot = NSDiffableDataSourceSnapshot<String, Card>
  
  // MARK: - Property
  
  private let viewModel: CalendarViewModelProtocol
  weak var calendarCoordinator: CalendarCoordinator?
  lazy var dataSource = configureDataSource()
  
  @IBOutlet private weak var dateLabel: DateLabel!
  @IBOutlet private weak var currentDateLabel: UILabel!
  @IBOutlet private weak var cardTableView: CardTableView!
  
  
  // MARK: - Initializer
  
  init?(coder: NSCoder, viewModel: CalendarViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("This controller must be initialized with code")
  }
  
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindUI()
    viewModel.fetchInitializeDailyCards()
    configureDateLabelTapGesture()
    
    navigationController?.navigationBar.isHidden = true
  }
}


// MARK: - Extension

private extension CalendarViewController {
  
  // MARK:- Method
  
  func configureDateLabelTapGesture() {
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dateLabelDidTapped))
    dateLabel.addGestureRecognizer(tapRecognizer)
    dateLabel.isUserInteractionEnabled = true
  }
  
  @objc func dateLabelDidTapped() {
    calendarCoordinator?.didTapOnDate(selectedDate: Date())
  }
  
  func bindUI() {
    initializeCardTableViewBinding()
  }
  
  func initializeCardTableViewBinding() {
    viewModel.bindingInitializeCardTableView { [weak self] cards in
      DispatchQueue.main.async {
        self?.updateSnapshot(with: cards, animatingDifferences: false)
      }
    }
  }
  
  func updateCardTableViewBinding() {
    viewModel.bindingUpdateCardTableView { [weak self] cards in
      DispatchQueue.main.async {
        self?.updateSnapshot(with: cards)
      }
    }
  }

  func configureDataSource() -> DataSource {
    let dataSource = DataSource(
      tableView: cardTableView) { (tableView, indexPath, card) -> UITableViewCell? in
      let cell: CardTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
      
      cell.update(with: card)
      
      return cell
    }
    
    return dataSource
  }
  
  func updateSnapshot(with item: Cards, animatingDifferences: Bool = true) {
    var snapshot = Snapshot()

    item.cards.forEach { card in
      snapshot.appendSections([String(card.id)])
      snapshot.appendItems([card])
    }
    
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }
}
