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

protocol CalendarViewControllerDelegate: AnyObject {
  func send(selectedDate: String)
}

final class CalendarViewController: UIViewController {
  
  typealias DataSource = UICollectionViewDiffableDataSource<String, Card>
  typealias Snapshot = NSDiffableDataSourceSnapshot<String, Card>
  
  // MARK: - Property
  
  private let viewModel: CalendarViewModelProtocol
  weak var calendarCoordinator: CalendarCoordinator?
  lazy var dataSource = configureDataSource()

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
}


// MARK: - Extension

private extension CalendarViewController {
  
  // MARK:- Method
  
  func configure() {
    cardCollectionView.delegate = self
    viewModel.fetchInitializeDailyCards()
      
    dateStepper.delegate = self
    viewModel.initializeDate()

    navigationController?.navigationBar.isHidden = true
  }
  
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


// MARK: DateStepperDelegate

extension CalendarViewController: DateStepperDelegate {
  func arrowDidTapped(direction: Direction, with date: String) {
    viewModel.changeDate(to: date, direction: direction)
  }
  
  func dateLabelDidTapped(of date: String) {
    calendarCoordinator?.didTapOnDate(selectedDate: date.toDate(), delegate: self)
  }
}


// MARK: CalendarViewControllerDelegate

extension CalendarViewController: CalendarViewControllerDelegate {
  
  func send(selectedDate: String) {
    viewModel.changeDate(to: selectedDate, direction: nil)
  }
}


// MARK: CardCellDelegate

extension CalendarViewController: CardCellDelegate {
  
  func delete(cardCell: CardCollectionViewCell) {
    if let indexPath = cardCollectionView.indexPath(for: cardCell),
       let item = dataSource.itemIdentifier(for: indexPath) {
      var snapshot = dataSource.snapshot()
      snapshot.deleteItems([item])
      
    }
  }
  
  func resetCellOffset(without cell: CardCollectionViewCell) {
    cardCollectionView.resetVisibleCellOffset(without: cell)
  }
}


// MARK: UICollectionViewDelegate

extension CalendarViewController: UICollectionViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    cardCollectionView.resetVisibleCellOffset()
  }
}
