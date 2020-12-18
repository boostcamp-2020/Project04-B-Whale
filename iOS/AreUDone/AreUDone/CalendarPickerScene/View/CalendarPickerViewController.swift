//
//  CalendarPickerViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/24.
//

import UIKit

protocol CalendarPickerViewControllerDelegate: AnyObject {
  
  func send(selectedDate: String)
}

final class CalendarPickerViewController: UIViewController {
  
  enum Section {
    case main
  }
  
  typealias DataSource = UICollectionViewDiffableDataSource<Section, Day>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Day>
  
  
  // MARK: - Property
  
  private lazy var dimmedBackgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  private lazy var headerView: CalendarPickerHeaderView = {
    let view = CalendarPickerHeaderView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  private lazy var collectionView: CalendarCollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    let collectionView = CalendarCollectionView(
      frame: .zero,
      collectionViewLayout: layout
    ) { [weak self] direction in
      
      switch direction {
      case .right:
        self?.viewModel.fetchUpdatedCalendar(to: -1)
        
      case .left:
        self?.viewModel.fetchUpdatedCalendar(to: 1)
      }
    }
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    return collectionView
  }()
  
  private lazy var timeSettingActionSheet: UIAlertController = {
    let alert = UIAlertController(
      alertType: .timePicker,
      alertStyle: .actionSheet,
      confirmAction: {
        let date = self.timePicker.date
        self.viewModel.updateSelectedDate(to: date)
      })
    
    return alert
  }()
  
  private lazy var timePicker: UIDatePicker = {
    let datePicker = UIDatePicker()
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    datePicker.datePickerMode = .time
    datePicker.locale = Locale.current
    if #available(iOS 13.4, *) {
      datePicker.preferredDatePickerStyle = .wheels
    }
    return datePicker
  }()
  
  private let viewModel: CalendarPickerViewModelProtocol
  lazy var dataSource = configureDataSource()
  
  //TODO:- 물어보기 delegate의 위치와 이름
  weak var delegate: CalendarPickerViewControllerDelegate?
  weak var coordinator: CalendarPickerViewCoordinator?
  
  
  // MARK: - Initializer
  
  init(viewModel: CalendarPickerViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(nibName: nil, bundle: nil)
    
    modalPresentationStyle = .overCurrentContext
    modalTransitionStyle = .crossDissolve
  }
  
  required init?(coder: NSCoder) {
    fatalError("This controller must be initialized with code")
  }
  
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindUI()
    addGestureRecognizer()
    configure()

    viewModel.fetchInitialCalendar()
  }
}


// MARK:- Extension bindUI

private extension CalendarPickerViewController {
  
  func bindUI() {
    bindingInitializeDate()
    bindingUpdateCalendar()
    bindingSendSelectedDate()
  }
  
  func bindingInitializeDate() {
    viewModel.bindingInitializeDate { [weak self] days, selectedDate in
      DispatchQueue.main.async {
        self?.updateSnapshot(with: days, animatingDifferences: false)
        self?.headerView.baseDate = selectedDate
        self?.timePicker.date = selectedDate
      }
    }
  }
  
  func bindingUpdateCalendar() {
    viewModel.bindingUpdateCalendar { [weak self] days, selectedDate in
      DispatchQueue.main.async {
        self?.updateSnapshot(with: days)
        self?.headerView.baseDate = selectedDate
        self?.timePicker.date = selectedDate
      }
    }
  }
  
  func bindingSendSelectedDate() {
    viewModel.bindingSendSelectedDate { [weak self] date in
      self?.delegate?.send(selectedDate: date)
    }
  }
}


// MARK: Constraints 설정

private extension CalendarPickerViewController {
  
  func configure() {
    collectionView.delegate = self
    if !(delegate is CalendarViewController) {
      headerView.delegate = self
      headerView.prepareForTimeSetting()
    }
    
    view.addSubview(dimmedBackgroundView)
    view.addSubview(collectionView)
    view.addSubview(headerView)
    
    configureDimmerViewConstraints()
    configureCollectionViewConstraints()
    configureHeaderViewConstraints()
    configureTimeSettingActionSheet()
  }
  
  func configureDimmerViewConstraints() {
    NSLayoutConstraint.activate([
      dimmedBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      dimmedBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      dimmedBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
      dimmedBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  func configureCollectionViewConstraints() {
    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
      collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 10),
      collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
    ])
  }
  
  func configureHeaderViewConstraints() {
    NSLayoutConstraint.activate([
      headerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
      headerView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
      headerView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
      headerView.heightAnchor.constraint(equalToConstant: 85)
    ])
  }
  
  func configureTimeSettingActionSheet() {
    timeSettingActionSheet.view.addSubview(timePicker)
      timeSettingActionSheet.view.heightAnchor.constraint(equalToConstant: 250).isActive = true
      
      NSLayoutConstraint.activate([
        timePicker.leadingAnchor.constraint(equalTo: timeSettingActionSheet.view.leadingAnchor),
        timePicker.trailingAnchor.constraint(equalTo: timeSettingActionSheet.view.trailingAnchor),
        timePicker.topAnchor.constraint(equalTo: timeSettingActionSheet.view.topAnchor, constant: 20),
        timePicker.bottomAnchor.constraint(equalTo: timeSettingActionSheet.view.bottomAnchor),
        timePicker.heightAnchor.constraint(equalTo: timeSettingActionSheet.view.heightAnchor, multiplier: 0.5)
      ])
  }
  
  func addGestureRecognizer() {
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dimmerViewDidTapped))
    dimmedBackgroundView.addGestureRecognizer(tapRecognizer)
  }
}


// MARK:- Extension obj-c

private extension CalendarPickerViewController {
  
  @objc func dimmerViewDidTapped() {
    viewModel.sendSelectedDate()
    coordinator?.dismiss()
  }
}


// MARK: Diffable DataSource

private extension CalendarPickerViewController {
  
  func configureDataSource() -> DataSource {
    let datasource = DataSource(
      collectionView: collectionView
    ) { [weak self] collectionView, indexPath, day -> UICollectionViewCell? in
      let cell: CalendarDateCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      cell.day = day
      
      if let dayNumber = Int(day.number),
         day.isWithinDisplayedMonth {
        self?.viewModel.prepareForCardCount(with: dayNumber) { count in
          DispatchQueue.main.async {
            cell.updateCountView(with: count)
          }
        }
      }
      
      return cell
    }
    
    return datasource
  }
  
  func updateSnapshot(with item: [Day], animatingDifferences: Bool = true) {
    var snapshot = Snapshot()
    
    snapshot.appendSections([.main])
    snapshot.appendItems(item)
    
    UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
      self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }.startAnimation()
    
  }
}


// MARK: UICollectionViewDelegateFlowLayout

extension CalendarPickerViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarDateCollectionViewCell,
          let day = cell.day else { return }
    
    viewModel.updateSelectedDate(to: day.date)
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


extension CalendarPickerViewController: CalendarPickerHeaderViewDelegate {
  
  func HeaderViewTimeSettingButtonTapped() {
    present(timeSettingActionSheet, animated: true)
  }
}
