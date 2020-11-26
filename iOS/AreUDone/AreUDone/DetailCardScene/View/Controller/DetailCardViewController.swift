//
//  DetailCardViewController.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/25.
//

import UIKit

enum CommentSection {
  case main
}

final class DetailCardViewController: UIViewController {
  
  typealias DataSource = UICollectionViewDiffableDataSource<CommentSection, Comment>
  typealias Snapshot = NSDiffableDataSourceSnapshot<CommentSection, Comment>
  
  // MARK:- Property
  
  private let viewModel: DetailCardViewModelProtocol
  private var observer: NSKeyValueObservation?
  private lazy var height = commentCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
  private lazy var dataSource = configureDataSource()

  
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    
    return scrollView
  }()
  
  private lazy var stackView: DetailCardStackView = {
    let stackView = DetailCardStackView()
    
    return stackView
  }()
  
  private lazy var commentTableView: UITableView = {
    let tableView = UITableView()
    
    return tableView
  }()
  
  private lazy var commentCollectionView: CommentCollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = CommentCollectionView(frame: CGRect(x: 0, y: 0, width: 320, height: 300), collectionViewLayout: layout)
    
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
      
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.viewModel.fetchDetailCard()
    
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    
  }
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    
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
    snapshot.appendItems(item)
    
    DispatchQueue.main.async {
      self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
  }
}


// MARK:- Extension Configure Method

private extension DetailCardViewController {
  
  func configure() {
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationBar.prefersLargeTitles = true
    
    view.addSubview(scrollView)
    
    configureScrollView()
    configureStackView()
    configureCommentcollectionView()
//    configureCommentTableView()
    
  }
  
  func configureScrollView() {
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
  
  func configureStackView() {
    scrollView.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
    ])
  }
  
  func configureCommentTableView() {
    stackView.addArrangedSubview(commentTableView)
    commentTableView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      commentTableView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
      commentTableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
    ])
  }
  
  func configureCommentcollectionView() {
    scrollView.addSubview(commentCollectionView)
    commentCollectionView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      commentCollectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
      commentCollectionView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
      commentCollectionView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
      commentCollectionView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
      height
//      commentCollectionView.heightAnchor.constraint(lessThanOrEqualToConstant: 0)
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
        self?.updateSnapshot(with: comments, animatingDifferences: false)
      }
    }
  }
}
