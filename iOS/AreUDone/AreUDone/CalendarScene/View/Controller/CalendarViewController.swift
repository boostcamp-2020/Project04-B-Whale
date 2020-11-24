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
  
  typealias DataSource = UICollectionViewDiffableDataSource<String, Card>
  typealias Snapshot = NSDiffableDataSourceSnapshot<String, Card>
  
  // MARK: - Property
  
  private let viewModel: CalendarViewModelProtocol
  weak var calendarCoordinator: CalendarCoordinator?
  lazy var dataSource = configureDataSource()
  
  @IBOutlet private weak var dateLabel: DateLabel!
  @IBOutlet private weak var currentDateLabel: UILabel!
  @IBOutlet weak var cardCollectionView: UICollectionView!
  
  
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
    navigationController?.navigationBar.isHidden = true
  }
}


// MARK: - Extension

private extension CalendarViewController {
  
  // MARK:- Method
  
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
      collectionView: cardCollectionView
    ) { (collectionView, indexPath, card) -> UICollectionViewCell? in
      let cell: CardCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      
      cell.updateCell(with: card)
      cell.delegate = self
      
      return cell
    }
    
    return dataSource
  }
  
  func updateSnapshot(with item: Cards, animatingDifferences: Bool = true) {
    var snapshot = Snapshot()

    snapshot.appendSections([""])
    snapshot.appendItems(item.cards)
    
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }
}


// MARK:- Extension

extension CalendarViewController: CardCellDelegate {
  func delete(cardCell: CardCollectionViewCell) {
    if let indexPath = cardCollectionView.indexPath(for: cardCell),
       let item = dataSource.itemIdentifier(for: indexPath) {
      var snapshot = dataSource.snapshot()
      snapshot.deleteItems([item])
      
    }
  }
}
