//
//  CardDetailViewController.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/25.
//

import UIKit

enum CommentSection: CaseIterable {
  case main
}

final class CardDetailViewController: UIViewController {
  
  typealias DataSource = UICollectionViewDiffableDataSource<CommentSection, CardDetail.Comment>
  typealias Snapshot = NSDiffableDataSourceSnapshot<CommentSection, CardDetail.Comment>
  
  // MARK:- Property
  
  private let viewModel: CardDetailViewModelProtocol
  private lazy var dataSource = configureDataSource()
  
  private lazy var scrollView: UIScrollView = {
    let view = UIScrollView()
    view.showsVerticalScrollIndicator = false
    view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    
    return view
  }()
  
  private lazy var stackView: CardDetailStackView = {
    let stackView = CardDetailStackView()
    
    return stackView
  }()
  
  private lazy var commentCollectionView: CommentCollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = CommentCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    
    return collectionView
  }()
  
  private lazy var commentView: CommentView = {
    let view = CommentView()
    
    return view
  }()
  
  
  // MARK:- Initializer
  
  init?(coder: NSCoder, viewModel: CardDetailViewModelProtocol) {
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
    
    viewModel.fetchDetailCard()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.isHidden = false
  }
}


// MARK:- Extension CollectionView DataSource

private extension CardDetailViewController {
  
  func configureDataSource() -> DataSource {
    let dataSource = DataSource(
      collectionView: commentCollectionView
    ) { (collectionView, indexPath, comment) -> UICollectionViewCell? in
      let cell: CommentCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      
      cell.update(with: comment)
      
      return cell
    }
    
    dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
      let header: CommentCollectionViewHeader = collectionView.dequeReusableHeaderView(forIndexPath: indexPath)
      
      return header
    }
    
    return dataSource
  }
  
  func updateSnapshot(with item: [CardDetail.Comment], animatingDifferences: Bool = true) {
    var snapshot = Snapshot()
    
    snapshot.appendSections([.main])
    snapshot.appendItems(item, toSection: .main)
    
    DispatchQueue.main.async {
      self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
  }
}


// MARK:- Extension Configure Method

private extension CardDetailViewController {
  
  func configure() {
    configureView()
    configureScrollView()
    configureStackView()
    configureCommentView()
    addEndEdittingGesture()
  }
  
  func configureView() {
    commentView.delegate = self
    scrollView.delegate = self
    stackView.setupContentViewDelegate(self)
    stackView.setupDueDateViewDelegate(self)
    
    addKeyboardNotification()
    
    view.addSubview(scrollView)
    view.addSubview(commentView)
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
      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
    ])
  }
  
  func configureCommentView() {
    commentView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      commentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      commentView.heightAnchor.constraint(equalToConstant: 60),
      commentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      commentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
  
  func addEndEdittingGesture() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditing))
    tapGestureRecognizer.delegate = self
    view.addGestureRecognizer(tapGestureRecognizer)
  }
  
  func addKeyboardNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
}


// MARK:- Extension BindUI

private extension CardDetailViewController {
  
  func bindUI() {
    bindingCardDetailContentView()
    bindingCardDetailDueDateView()
    bindingCardDetailCommentTableView()
    bindingCardDetailNavigationBarTitle()
    bindingCardDetailListTitle()
    bindingCardDetailBoardTitle()
  }
  
  func bindingCardDetailContentView() {
    viewModel.bindingCardDetailContentView { [weak self] content in
      self?.stackView.updateContentView(with: content)
    }
  }
  
  func bindingCardDetailDueDateView() {
    viewModel.bindingCardDetailDueDateView { [weak self] dueDate in
      self?.stackView.updateDueDateView(with: dueDate)
    }
  }
  
  func bindingCardDetailCommentTableView() {
    viewModel.bindingCardDetailCommentTableView { [weak self] comments in
      DispatchQueue.main.async {
        self?.updateSnapshot(with: comments, animatingDifferences: true)
      }
    }
  }
  
  func bindingCardDetailNavigationBarTitle() {
    viewModel.bindingCardDetailNavigationBarTitle { [weak self] title in
      self?.navigationItem.title = title
    }
  }
  
  func bindingCardDetailListTitle() {
    viewModel.bindingCardDetailListTitle { [weak self] title in
      self?.stackView.updateListOfLocationView(with: title)
    }
  }
  
  func bindingCardDetailBoardTitle() {
    viewModel.bindingCardDetailBoardTitle { [weak self] title in
      self?.stackView.updateBoardOfLocationView(with: title)
    }
  }
}


// MARK:- Extension obj-c

private extension CardDetailViewController {
  
  @objc func keyboardWillShow(_ notification: Notification) {
    if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let keybaordRectangle = keyboardFrame.cgRectValue
      let keyboardHeight = keybaordRectangle.height
      commentView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
      stackView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
    }
  }
  
  @objc func keyboardWillHide(_ notification: Notification) {
    commentView.transform = .identity
    stackView.transform = .identity
  }
  
  @objc func endEditing() {
    view.endEditing(true)
  }
}


// MARK:- Extension CommentViewDelegate

extension CardDetailViewController: CommentViewDelegate {
  
  func commentSaveButtonTapped(with comment: String) {
    viewModel.addComment(with: comment)
  }
}


// MARK:- Extension ScrollViewDelegate

extension CardDetailViewController: UIScrollViewDelegate {
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    view.endEditing(true)
  }
}


// MARK:- Extension UIGestureRecognizerDelegate

extension CardDetailViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return touch.view?.isDescendant(of: commentView) == true ? false : true
  }
}


// MARK:- Extension CardDetailContentViewDelegate

extension CardDetailViewController: CardDetailContentViewDelegate {
  
  func cardDetailContentEditButtonTapped() {
    
  }
}


// MARK:- Extension CardDetailDueDateViewDelegate

extension CardDetailViewController: CardDetailDueDateViewDelegate {
  
  func cardDetailDueDateEditButtonTapped() {
    
  }
}
