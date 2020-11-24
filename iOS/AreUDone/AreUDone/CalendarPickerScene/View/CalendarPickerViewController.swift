//
//  CalendarPickerViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/24.
//

import UIKit

class CalendarPickerViewController: UIViewController {
  
  enum Section {
    case main
  }
  
  typealias DataSource = UICollectionViewDiffableDataSource<Section, Day>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Day>
  

  // MARK: Views
  private lazy var dimmedBackgroundView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    return view
  }()
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .systemGroupedBackground
    collectionView.isScrollEnabled = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()
  
  private lazy var headerView = CalendarPickerHeaderView { [weak self] in
    guard let self = self else { return }
    
    self.dismiss(animated: true)
  }
  
  private lazy var footerView = CalendarPickerFooterView(
    didTapLastMonthCompletionHandler: { [weak self] in
      guard let self = self else { return }
      
      self.viewModel.fetchUpdateMonth(to: -1)
    },
    didTapNextMonthCompletionHandler: { [weak self] in
      guard let self = self else { return }
      
      self.viewModel.fetchUpdateMonth(to: 1)
    })

  
  private let selectedDateChanged: ((Date) -> Void)
  private let calendar = Calendar(identifier: .gregorian)
  
  private lazy var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d"
    return dateFormatter
  }()
  
  private let viewModel: CalendarPickerViewModelProtocol
  lazy var dataSource = configureDataSource()

  
  // MARK: - Initializer
  
  init(viewModel: CalendarPickerViewModelProtocol, selectedDateChanged: @escaping ((Date) -> Void)) {
    self.viewModel = viewModel
    self.selectedDateChanged = selectedDateChanged
    
    super.init(nibName: nil, bundle: nil)
    
    modalPresentationStyle = .overCurrentContext
    modalTransitionStyle = .crossDissolve
//    definesPresentationContext = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("This controller must be initialized with code")
  }
  
  // MARK: - Life Cycle
  
  func 
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindUI()
    viewModel.fetchInitialData()
    
    gestureRecognizer()
    
    view.addSubview(dimmedBackgroundView)
    view.addSubview(collectionView)
    view.addSubview(headerView)
    view.addSubview(footerView)
    
    var constraints = [
      dimmedBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      dimmedBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      dimmedBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
      dimmedBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ]
    
    constraints.append(contentsOf: [
      collectionView.leadingAnchor.constraint(
        equalTo: view.readableContentGuide.leadingAnchor),
      collectionView.trailingAnchor.constraint(
        equalTo: view.readableContentGuide.trailingAnchor),
      collectionView.centerYAnchor.constraint(
        equalTo: view.centerYAnchor,
        constant: 10),
      collectionView.heightAnchor.constraint(
        equalTo: view.heightAnchor,
        multiplier: 0.5)
    ])
    
    constraints.append(contentsOf: [
      headerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
      headerView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
      headerView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
      headerView.heightAnchor.constraint(equalToConstant: 85),
      
      footerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
      footerView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
      footerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
      footerView.heightAnchor.constraint(equalToConstant: 60)
    ])
    
    NSLayoutConstraint.activate(constraints)
    
    collectionView.register(
      CalendarDateCollectionViewCell.self,
      forCellWithReuseIdentifier: CalendarDateCollectionViewCell.reuseIdentifier
    )
    
    collectionView.delegate = self
  }
  

  @objc func didSwipe(recognizer: UISwipeGestureRecognizer) {
    
    switch recognizer.direction {
    case .left:
      self.viewModel.fetchUpdateMonth(to: -1)
    case .right:
      self.viewModel.fetchUpdateMonth(to: 1)
    default:
      break
    }
  }
  
  func gestureRecognizer() {
    
    let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
    leftSwipeGesture.direction = .left
    
    let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
    rightSwipeGesture.direction = .right
    
    collectionView.addGestureRecognizer(leftSwipeGesture)
    collectionView.addGestureRecognizer(rightSwipeGesture)
    
    
    
  }
  
}

extension CalendarPickerViewController {
  
  func bindUI() {
    viewModel.bindingInitialize { days, selectedDate in
      self.updateSnapshot(with: days, animatingDifferences: false)
      self.headerView.baseDate = selectedDate
      
    }
    
    viewModel.bindingUpdate { days, selectedDate in
      self.updateSnapshot(with: days)
      self.headerView.baseDate = selectedDate

    }
    
    viewModel.bindingChangeSelectedDate { days in
      self.updateSnapshot(with: days)
    }
  }
  
  
  func configureDataSource() -> DataSource {
    let datasource = DataSource(collectionView: collectionView) { collectionView, indexPath, day -> UICollectionViewCell? in
      let cell: CalendarDateCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      
      cell.day = day
      
      return cell
    }
    
    return datasource
  }
  
  func updateSnapshot(with item: [Day], animatingDifferences: Bool = true) {
    var snapshot = Snapshot()

    snapshot.appendSections([.main])
    snapshot.appendItems(item)
    
    
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }
  
}


// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarPickerViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! CalendarDateCollectionViewCell
    viewModel.changeSelectedDate(to: cell.day!.date)
    print("선택", cell.day!.date)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let width = Int(collectionView.frame.width / 7)
    let height = Int(collectionView.frame.height) / 6
    return CGSize(width: width, height: height)
  }
}


