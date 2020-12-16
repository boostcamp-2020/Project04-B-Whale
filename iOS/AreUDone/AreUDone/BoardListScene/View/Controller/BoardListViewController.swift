//
//  BoardListViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import UIKit

final class BoardListViewController: UIViewController {
  
  // MARK: Type Alias
  
  typealias DataSource = UICollectionViewDiffableDataSource<Section, Board>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Board>
  
  
  // MARK: - Enum
  
  enum Section {
    case main
  }
  
  
  // MARK: - Property
  
  weak var coordinator: BoardListCoordinator?
  private let viewModel: BoardListViewModelProtocol
  private let sectionFactory: SectionContentsFactoryable
  
  lazy var dataSource = configureDataSource()
  
  @IBOutlet weak var titleView: UILabel!
  @IBOutlet weak var addBoardButton: UIImageView! {
    didSet {
      addBoardButton.isUserInteractionEnabled = true
    }
  }
  @IBOutlet weak var baseView: UIView! {
    didSet {
      baseView.backgroundColor = .clear
      baseView.addShadow(
        offset: .zero,
        radius: 3,
        opacity: 0.5
      )
    }
  }
  @IBOutlet weak var collectionView: BoardListCollectionView! {
    didSet {
      collectionView.delegate = self
    }
  }
  @IBOutlet weak var segmentControl: CustomSegmentedControl! {
    didSet {
      let boardTitles = BoardSegment.allCases.map { $0.text }
      segmentControl.setButtonTitles(buttonTitles: boardTitles)
      segmentControl.delegate = self
    }
  }
  
  private lazy var emptyIndicatorView: EmptyIndicatorView = {
    let view = EmptyIndicatorView(emptyType: .boardEmpty)
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  
  // MARK: - Initializer
  
  required init?(
    coder: NSCoder,
    viewModel: BoardListViewModelProtocol,
    sectionFactory: SectionContentsFactoryable
  ) {
    self.viewModel = viewModel
    self.sectionFactory = sectionFactory
    
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = true
    
    viewModel.fetchBoard()
  }
}


// MARK: - Extension Configure Method

private extension BoardListViewController {
  
  func configure() {
    view.addSubview(emptyIndicatorView)
    
    configureView()
    configureAddBoardButton()
    configureEmptyIndicatorView()
  }
  
  func configureView() {
    navigationController?.navigationBar.prefersLargeTitles = true
    
    navigationItem.title = "보드 목록"
  }
  
  func configureAddBoardButton() {
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addBoardButtonTapped))
    addBoardButton.addGestureRecognizer(gestureRecognizer)
  }
  
  func configureEmptyIndicatorView() {
    NSLayoutConstraint.activate([
      emptyIndicatorView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
      emptyIndicatorView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
    ])
  }
}


// MARK:- Extension bindUI

private extension BoardListViewController {
  
  func bindUI() {
    bindingUpdateBoarListCollectionView()
    bindingDidBoardTapped()
    bindingEmptyIndicatorView()
  }
  
  func bindingUpdateBoarListCollectionView() {
    viewModel.bindingUpdateBoardListCollectionView { [weak self] boards in
      self?.updateSnapshot(with: boards)
    }
  }
  
  func bindingDidBoardTapped() {
    viewModel.bindingDidBoardTapped { [weak self] boardId in
      self?.coordinator?.pushToBoardDetail(boardId: boardId)
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

// MARK: - Extension Diffable DataSource

private extension BoardListViewController {
  
  func configureDataSource() -> DataSource {
    let dataSource = DataSource(
      collectionView: collectionView
    ) { (collectionView, indexPath, board) -> UICollectionViewCell? in
      let cell: BoardListCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      cell.update(with: board)
      
      return cell
    }
    
    return dataSource
  }
  
  func updateSnapshot(with boards: [Board], animatingDifferences: Bool = true) {
    var snapshot = Snapshot()
    
    snapshot.appendSections([.main])
    snapshot.appendItems(boards, toSection: .main)
    
    DispatchQueue.main.async {
      self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
  }
}

// MARK: - Extension UICollectionViewDelegate

extension BoardListViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let board = dataSource.itemIdentifier(for: indexPath) else { return }
    viewModel.fetchBoardId(for: board)
  }
}


// MARK: - Extension SegmentControl

extension BoardListViewController: CustomSegmentedControlDelegate {
  
  func change(to segmented: TitleChangeable) {
    titleView.text = segmented.text
    UIView.transition(
      with: titleView,
      duration: 0.3,
      options: .transitionFlipFromLeft,
      animations: nil,
      completion: nil)
    
    switch segmented {
    case BoardSegment.myBoard:
      viewModel.changeBoardOption(option: .myBoards)
      
    case BoardSegment.invitedBoard:
      viewModel.changeBoardOption(option: .invitedBoards)
    default:
      break
    }
  }
}


// MARK: - Extension objc

private extension BoardListViewController {
  
  @objc func addBoardButtonTapped() {
    coordinator?.presentBoardAdd()
  }
}
