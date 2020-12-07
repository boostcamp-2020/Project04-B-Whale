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
  enum Section: CaseIterable {
    case main
  }
  
  enum BoardSegment: String, CaseIterable {
    case myBoard = "나의 보드"
    case invitedBoard = "공유 보드"
  }
  
  
  // MARK: - Property
  
  weak var coordinator: BoardListCoordinator?
  private let viewModel: BoardListViewModelProtocol
  private let sectionFactory: SectionContentsFactoryable
  
  lazy var dataSource = configureDataSource()
  
  @IBOutlet weak var titleView: UILabel!
  @IBOutlet weak var addBoardButton: UIImageView!
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
      let boardTitles = BoardSegment.allCases.map { $0.rawValue }
      segmentControl.setButtonTitles(buttonTitles: boardTitles)
      segmentControl.delegate = self
      
      segmentControl.layer.cornerRadius = 10
      segmentControl.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
      segmentControl.addShadow(
        offset: CGSize(width: 0, height: -1),
        radius: 2,
        opacity: 0.5
      )
    }
  }
  
  
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
    viewModel.fetchMyBoard()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.isNavigationBarHidden = false
  }
}


// MARK: - Extension Configure Method

private extension BoardListViewController {
  
  func configure() {
    configureView()
    configureAddBoardButton()
  }
  
  func configureView() {
    navigationController?.navigationBar.prefersLargeTitles = true
    
    navigationItem.title = "보드 목록"
  }
  
  func configureAddBoardButton() {
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addBoardButtonTapped))
    addBoardButton.addGestureRecognizer(gestureRecognizer)
  }
  
  @objc func addBoardButtonTapped() {
    // TODO: 보드 추가 화면 프레젠테이션 로직
  }
}


// MARK:- Extension bindUI

private extension BoardListViewController {
  
  func bindUI() {
    viewModel.bindingUpdateBoardListCollectionView { boards in
      self.updateSnapshot(with: boards)
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
    // TODO: boardId 받아오는 메소드 작성
    coordinator?.boardItemDidTapped(boardId: 0)
  }
}


// MARK: - Extension SegmentControl

extension BoardListViewController: CustomSegmentedControlDelegate {
  
  func change(to title: String) {
    self.titleView.text = title
    UIView.transition(
      with: titleView,
      duration: 0.3,
      options: .transitionFlipFromLeft,
      animations: nil,
      completion: nil)
    
    switch title {
    case BoardSegment.myBoard.rawValue:
      viewModel.fetchMyBoard()
    case BoardSegment.invitedBoard.rawValue:
      viewModel.fetchInvitedBoard()
    default:
      break
    }
  }
}
