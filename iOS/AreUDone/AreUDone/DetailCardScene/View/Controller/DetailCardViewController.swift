//
//  DetailCardViewController.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/25.
//

import UIKit

enum CommentSection: CaseIterable {
  case main
}

final class DetailCardViewController: UIViewController {
  
  typealias DataSource = UICollectionViewDiffableDataSource<CommentSection, Comment>
  typealias Snapshot = NSDiffableDataSourceSnapshot<CommentSection, Comment>
  
  // MARK:- Property
  
  private let viewModel: DetailCardViewModelProtocol
  private var observer: NSKeyValueObservation?
  private lazy var dataSource = configureDataSource()
  
  private lazy var scrollView: UIScrollView = {
    let view = UIScrollView()
    view.showsVerticalScrollIndicator = false
    return view
  }()
  
  private lazy var stackView: DetailCardStackView = {
    let stackView = DetailCardStackView()
    
    return stackView
  }()
  
  private lazy var commentCollectionView: CommentCollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = CommentCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    
    return collectionView
  }()
  
  
  // MARK:- Initializer
  
  init?(coder: NSCoder, viewModel: DetailCardViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("This controller must be initialized with code")
  }
  
  
  // MARK:- Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    bindUI()
    
    DispatchQueue.main.async {
      self.viewModel.fetchDetailCard()
    }
  }
}


// MARK:- Extension

private extension DetailCardViewController {
  
  func configureDataSource() -> DataSource {
    let dataSource = DataSource(
      collectionView: commentCollectionView
    ) { (collectionView, indexPath, comment) -> UICollectionViewCell? in
      let cell: CommentCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      
      cell.update(with: comment)
      
      return cell
    }
    
    return dataSource
  }
  
  func updateSnapshot(with item: [Comment], animatingDifferences: Bool = true) {
    var snapshot = Snapshot()

    snapshot.appendSections([.main])
    snapshot.appendItems(item, toSection: .main)
    
    DispatchQueue.main.async {
      self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
  }
}


// MARK:- Extension Configure Method

private extension DetailCardViewController {
  
  func configure() {
    configureView()
    configureScrollView()
    configureStackView()
  }
  
  func configureView(){
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationBar.prefersLargeTitles = true
    
    view.addSubview(scrollView)
    scrollView.addSubview(stackView)
    stackView.addArrangedSubview(commentCollectionView)
  }
  
  func configureScrollView() {
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
    ])
  }
  
  func configureStackView() {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
    ])
  }
}


// MARK:- Extension BindUI

private extension DetailCardViewController {
  
  private func bindUI() {
    observationNavigationBar()
    bindingDetailCardContentView()
    bindingDetailCardDueDateView()
    bindingDetailCardCommentTableView()
  }
  
  private func observationNavigationBar() {
    observer = navigationController?.navigationBar.observe(
      \.bounds,
      options: [.new, .initial],
      changeHandler: { (navigationBar, changes) in
        if let height = changes.newValue?.height {
          if height > 44.0 {
            //Large Title
          } else {
            //Small Title
          }
        }
      })
  }
  
  private func bindingDetailCardContentView() {
    viewModel.bindingDetailCardContentView { [weak self] content in
      self?.stackView.updateContentView(with: content)
    }
  }
  
  private func bindingDetailCardDueDateView() {
    viewModel.bindingDetailCardDueDateView { [weak self] dueDate in
      self?.stackView.updateDueDateView(with: dueDate)
    }
  }
  
  private func bindingDetailCardCommentTableView() {
    viewModel.bindingDetailCardCommentTableView { [weak self] comments in
      DispatchQueue.main.async {
        self?.updateSnapshot(with: comments, animatingDifferences: true)
      }
    }
  }
}
