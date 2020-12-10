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
  
  private lazy var dataSource = configureDataSource()
  
  @IBOutlet weak var dateStepper: DateStepper!
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


// MARK:- Extension CollectionView DataSource

private extension CalendarViewController {
  
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
    guard let cards = item.cards else { return }
    var snapshot = Snapshot()
    
    snapshot.appendSections([""])
    snapshot.appendItems(cards)
    
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }
}


// MARK: - Extension Configure Method

private extension CalendarViewController {
  
  func configure() {
    cardCollectionView.delegate = self
    viewModel.fetchInitializeDailyCards()
    
    dateStepper.delegate = self
    viewModel.initializeDate()
  }
}


// MARK:- Extension BindUI

private extension CalendarViewController {
  
  func bindUI() {
    bindingInitializeCardCollectionView()
    bindingUpdateDate()
  }
  
  func bindingInitializeCardCollectionView() {
    viewModel.bindingInitializeCardCollectionView { [weak self] cards in
      DispatchQueue.main.async {
        self?.updateSnapshot(with: cards, animatingDifferences: false)
      }
    }
  }
  
  func bindingUpdateCardCollectionView() {
    viewModel.bindingUpdateCardCollectionView { [weak self] cards in
      DispatchQueue.main.async {
        self?.updateSnapshot(with: cards)
      }
    }
  }
  
  func bindingUpdateDate() {
    viewModel.bindingUpdateDate { date in
      self.dateStepper.updateDate(date: date)
    }
  }
}

// MARK: DateStepperDelegate

extension CalendarViewController: DateStepperDelegate {
  
  func arrowDidTapped(direction: Direction, with dateString: String) {
    viewModel.changeDate(to: dateString, direction: direction)
  }
  
  func dateLabelDidTapped(of dateString: String) {
    calendarCoordinator?.didTapOnDate(selectedDate: dateString.toDateFormat(withDividerFormat: .dot), delegate: self)
  }
}


// MARK: Extension CalendarViewControllerDelegate

extension CalendarViewController: CalendarPickerViewControllerDelegate {
  
  func send(selectedDate: String) {
    viewModel.changeDate(to: selectedDate, direction: nil)
  }
}


// MARK: Extension CardCellDelegate

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
    guard let visibleCells = cardCollectionView.visibleCells as? [CardCollectionViewCell] else { return }
    for visibleCell in visibleCells {
      if visibleCell.isSwiped {
        cardCollectionView.resetVisibleCellOffset()
        return
      }
    }
    
    if let indexPath = cardCollectionView.indexPath(for: cell),
       let card = dataSource.itemIdentifier(for: indexPath) {
      calendarCoordinator?.showCardDetail(for: card.id)
    }
  }
}


// MARK: Extension UICollectionViewDelegate

extension CalendarViewController: UICollectionViewDelegate {
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    cardCollectionView.resetVisibleCellOffset()
  }
}
