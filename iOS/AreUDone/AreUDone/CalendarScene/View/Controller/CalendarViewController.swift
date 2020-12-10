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
  
  typealias DataSource = UICollectionViewDiffableDataSource<Section, Card>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Card>
  
  // MARK: - Property
  
  private let viewModel: CalendarViewModelProtocol
  weak var calendarCoordinator: CalendarCoordinator?

  private lazy var dataSource = configureDataSource()

  private lazy var cardCollectionView: CardCollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    let collectionView = CardCollectionView(
      frame: CGRect.zero,
      collectionViewLayout: flowLayout
    )
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    return collectionView
  }()
  
  private lazy var baseView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .clear
    view.addShadow(
      offset: .zero,
      radius: 3,
      opacity: 0.5
    )
    
    return view
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.nanumB(size: 30)
    label.text = "전체 카드"
    
    return label
  }()
  
  private lazy var dateStepper: DateStepper = {
    let dateStepper = DateStepper()
    dateStepper.translatesAutoresizingMaskIntoConstraints = false
    
    return dateStepper
  }()
  
  private lazy var segmentedControl: CustomSegmentedControl = {
    let segmentedControl = CustomSegmentedControl()
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    let titles = CardSegment.allCases.map { $0.text }
    segmentedControl.setButtonTitles(buttonTitles: titles)
    
    return segmentedControl
  }()

  
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
    viewModel.fetchInitializeDailyCards()
    
    dateStepper.delegate = self
    viewModel.initializeDate()
    
    configureView()
    configureTitleLabel()
    configureDateStepper()
    configureBaseView()
    configureCardCollectionView()
    configureSegmentedControl()
  }
  
  func configureView() {
    view.addSubview(titleLabel)
    view.addSubview(dateStepper)
    view.addSubview(baseView)
    baseView.addSubview(cardCollectionView)
    baseView.addSubview(segmentedControl)
  }
  
  func configureTitleLabel() {
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 10),
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      titleLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06)
    ])
  }
  
  func configureDateStepper() {
    NSLayoutConstraint.activate([
      dateStepper.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
      dateStepper.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
      dateStepper.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
      dateStepper.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
    ])
  }
  
  func configureBaseView() {
    NSLayoutConstraint.activate([
      baseView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
      baseView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
      baseView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
      baseView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
    ])
  }
  
  func configureCardCollectionView() {
    NSLayoutConstraint.activate([
      cardCollectionView.topAnchor.constraint(equalTo: baseView.topAnchor),
      cardCollectionView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
      cardCollectionView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
      cardCollectionView.bottomAnchor.constraint(equalTo: segmentedControl.topAnchor)
    ])
  }
  
  func configureSegmentedControl() {
    NSLayoutConstraint.activate([
      segmentedControl.bottomAnchor.constraint(equalTo: baseView.bottomAnchor),
      segmentedControl.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
      segmentedControl.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
      segmentedControl.heightAnchor.constraint(equalToConstant: 50),
    ])
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
    guard
      let indexPath = cardCollectionView.indexPath(for: cell),
      let item = dataSource.itemIdentifier(for: indexPath)
    else { return }
    
    viewModel.deleteCard(for: item.id) { [weak self] in
      guard let self = self else { return }
      var snapshot = self.dataSource.snapshot()
      snapshot.deleteItems([item])
      
      DispatchQueue.main.async {
        self.dataSource.apply(snapshot)
      }
    }
  }
  
  func resetCellOffset(without cell: CardCollectionViewCell) {
    cardCollectionView.resetVisibleCellOffset(without: cell)
  }
  
  func didSelect(for cell: CardCollectionViewCell) {
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


// MARK:- Extension CustomSegmentedControlDelegate

extension CalendarViewController: CustomSegmentedControlDelegate {
  
  func change(to title: TitleChangeable) {
    self.titleLabel.text = title.text
    UIView.transition(
      with: titleLabel,
      duration: 0.3,
      options: .transitionFlipFromLeft,
      animations: nil,
      completion: nil)
  }
}
