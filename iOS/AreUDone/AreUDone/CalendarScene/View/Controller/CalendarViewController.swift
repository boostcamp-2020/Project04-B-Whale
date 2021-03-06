//
//  CalendarViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/21.
//

import UIKit

final class CalendarViewController: UIViewController {
  
  typealias DataSource = UICollectionViewDiffableDataSource<SingleSection, Card>
  typealias Snapshot = NSDiffableDataSourceSnapshot<SingleSection, Card>
  
  // MARK: - Property
  
  private let viewModel: CalendarViewModelProtocol
  weak var calendarCoordinator: CalendarCoordinator?
  
  @IBOutlet private weak var cardCollectionView: CardCollectionView!
  @IBOutlet private weak var dateStepper: DateStepper!
  @IBOutlet private weak var baseView: UIView! {
    didSet {
      baseView.backgroundColor = .clear
      baseView.addShadow(
        offset: .zero,
        radius: 3,
        opacity: 0.5
      )
    }
  }
  @IBOutlet private weak var titleLabel: UILabel! {
    didSet {
      titleLabel.font = UIFont.nanumB(size: 30)
      titleLabel.text = "전체 카드"
    }
  }
  @IBOutlet private weak var segmentedControl: CustomSegmentedControl! {
    didSet {
      let titles = CardSegment.allCases.map { $0.text }
      segmentedControl.setButtonTitles(buttonTitles: titles)
    }
  }
  private lazy var emptyIndicatorView: EmptyIndicatorView = {
    let view = EmptyIndicatorView(emptyType: .cardEmpty)
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  private lazy var dataSource = configureDataSource()
  
  
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
    
    viewModel.fetchDailyCards()
  }
}


// MARK:- Extension CollectionView DataSource

private extension CalendarViewController {
  
  func configureDataSource() -> DataSource {
    let dataSource = DataSource(
      collectionView: cardCollectionView
    ) { [weak self] (collectionView, indexPath, card) -> UICollectionViewCell? in
      let cell: CardCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      
      cell.updateCell(with: card)
      cell.delegate = self
      
      return cell
    }
    
    return dataSource
  }
  
  func updateSnapshot(with item: Cards, animatingDifferences: Bool = true) {
    let cards = item.fetchCards()
    var snapshot = Snapshot()
    
    snapshot.appendSections([.main])
    snapshot.appendItems(cards)
    
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }
}


// MARK: - Extension Configure Method

private extension CalendarViewController {
  
  func configure() {
    segmentedControl.delegate = self
    cardCollectionView.delegate = self
    dateStepper.delegate = self
    
    configureView()
    configureEmptyIndicatorView()
  }
  
  func configureView() {
    view.addSubview(emptyIndicatorView)
  }
  
  func configureEmptyIndicatorView() {
    NSLayoutConstraint.activate([
      emptyIndicatorView.centerXAnchor.constraint(equalTo: cardCollectionView.centerXAnchor),
      emptyIndicatorView.centerYAnchor.constraint(equalTo: cardCollectionView.centerYAnchor),
      emptyIndicatorView.topAnchor.constraint(equalTo: cardCollectionView.topAnchor),
      emptyIndicatorView.leadingAnchor.constraint(equalTo: cardCollectionView.leadingAnchor)
    ])
  }
}


// MARK:- Extension BindUI

private extension CalendarViewController {
  
  func bindUI() {
    bindingUpdateCardCollectionView()
    bindingUpdateDate()
    bindingEmptyIndicatorView()
  }
  
  func bindingUpdateCardCollectionView() {
    viewModel.bindingUpdateCardCollectionView { [weak self] cards in
      DispatchQueue.main.async {
        self?.updateSnapshot(with: cards)
      }
    }
  }
  
  func bindingUpdateDate() {
    viewModel.bindingUpdateDate { [weak self] date in
      DispatchQueue.main.async {
        self?.dateStepper.updateDate(date: date)
      }
    }
  }
  
  func bindingEmptyIndicatorView() {
    viewModel.bindingEmptyIndicatorView { [weak self] isEmpty in
      DispatchQueue.main.async {
        self?.emptyIndicatorView.isHidden = isEmpty ? false : true
      }
    }
  }
}

// MARK: DateStepperDelegate

extension CalendarViewController: DateStepperDelegate {
  
  func arrowDidTapped(direction: Direction, with dateString: String) {
    viewModel.changeDate(to: dateString, direction: direction)
  }
  
  func dateLabelDidTapped(of dateString: String) {
    tabBarController?.tabBar.isUserInteractionEnabled = false
    calendarCoordinator?.presentCalendarPicker(
      selectedDate: dateString.toDateFormat(withDividerFormat: .dot),
      delegate: self
    )
  }
}


// MARK: Extension CalendarViewControllerDelegate

extension CalendarViewController: CalendarPickerViewControllerDelegate {
  
  func send(selectedDate: String) {
    tabBarController?.tabBar.isUserInteractionEnabled = true
    viewModel.changeDate(to: selectedDate, direction: nil)
  }
}


// MARK: Extension CardCellDelegate

extension CalendarViewController: CardCellDelegate {
  
  func remove(cell: CardCollectionViewCell) {
    guard
      let indexPath = cardCollectionView.indexPath(for: cell),
      let item = dataSource.itemIdentifier(for: indexPath)
    else { return }
    
    viewModel.deleteCard(for: item.id) { [weak self] in
      guard let self = self else { return }
      
      DispatchQueue.main.async {
        var snapshot = self.dataSource.snapshot()
        snapshot.deleteItems([item])
        self.viewModel.checkCardCollectionView(isEmpty: snapshot.itemIdentifiers.isEmpty)
        self.dataSource.apply(snapshot)
      }
    }
  }
  
  func resetCellOffset(without cell: CardCollectionViewCell) {
    cardCollectionView.resetVisibleCellOffset(without: cell)
  }
  
  func didSelect(for cell: CardCollectionViewCell) {
    guard let visibleCells = cardCollectionView.visibleCells as? [CardCollectionViewCell]
    else { return }
    
    for visibleCell in visibleCells {
      if visibleCell.isSwiped {
        cardCollectionView.resetVisibleCellOffset()
        return
      }
    }
    
    if let indexPath = cardCollectionView.indexPath(for: cell),
       let card = dataSource.itemIdentifier(for: indexPath) {
      calendarCoordinator?.pushToCardDetail(for: card.id)
    }
  }
}


// MARK: Extension UICollectionViewDelegate

extension CalendarViewController: UICollectionViewDelegate {
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    cardCollectionView.resetVisibleCellOffset()
  }
}


// MARK:- Extension CustomSegmentedControlDelegate

extension CalendarViewController: CustomSegmentedControlDelegate {
  
  func change(to segmented: TitleChangeable) {
    self.titleLabel.text = segmented.text
    UIView.transition(
      with: titleLabel,
      duration: 0.3,
      options: .transitionFlipFromLeft,
      animations: nil
    )
    
    switch segmented {
    case CardSegment.allCard:
      viewModel.fetchUpdateDailyCards(withOption: .allCard)
      
    case CardSegment.myCard:
      viewModel.fetchUpdateDailyCards(withOption: .myCard)
      
    default:
      return
    }
  }
}
