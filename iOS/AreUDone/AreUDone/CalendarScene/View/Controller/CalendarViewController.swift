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
  @IBOutlet weak var cardCollectionView: CardCollectionView!
  
  
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
    configure()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
  }
}


// MARK: - Extension

private extension CalendarViewController {
  
  // MARK:- Method
  
  func configure() {
    configureDateLabelTapGesture()
    cardCollectionView.delegate = self
    viewModel.fetchInitializeDailyCards()
  }
  
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


// MARK:- Extension CardCellDelegate

extension CalendarViewController: CardCellDelegate {
  
  func remove(cell: CardCollectionViewCell) {
    if let indexPath = cardCollectionView.indexPath(for: cell),
       let item = dataSource.itemIdentifier(for: indexPath) {
      var snapshot = dataSource.snapshot()
      snapshot.deleteItems([item])
      
    }
  }
  
  func resetCellOffset(without cell: CardCollectionViewCell) {
    cardCollectionView.resetVisibleCellOffset(without: cell)
  }
  
  func didSelect(for cell: CardCollectionViewCell) {
    if let indexPath = cardCollectionView.indexPath(for: cell),
       let card = dataSource.itemIdentifier(for: indexPath) {
      calendarCoordinator?.showDetailCard(for: card.id)
    }
  }
}


// MARK:- Extension UICollectionViewDelegate

extension CalendarViewController: UICollectionViewDelegate {
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    cardCollectionView.resetVisibleCellOffset()
  }
}
