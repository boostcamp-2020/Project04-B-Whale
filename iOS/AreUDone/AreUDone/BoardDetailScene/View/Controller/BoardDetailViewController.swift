//
//  BoardDetailViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import UIKit

final class BoardDetailViewController: UIViewController {
  
  // MARK: - Property
  
  private let viewModel: BoardDetailViewModelProtocol
  weak var coordinator: BoardDetailCoordinator?
  
  private lazy var titleTextField: UITextField = {
    let textField = UITextField()
    
    textField.returnKeyType = .done
    textField.delegate = self
    textField.textColor = .white
    
    return textField
  }()
  @IBOutlet private weak var collectionView: BoardDetailCollectionView! {
    didSet {
      collectionView.dataSource = self
      collectionView.delegate = self
    }
  }
  private let pageControl: UIPageControl = {
    let pageControl = UIPageControl()
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    
    return pageControl
  }()
  private var scrollOffset: CGFloat!
  
  private let sideBarViewController: SideBarViewControllerProtocol
  
  
  // MARK: - Initializer
  
  required init?(
    coder: NSCoder,
    viewModel: BoardDetailViewModelProtocol,
    sideBarViewController: SideBarViewControllerProtocol
  ) {
    self.viewModel = viewModel
    self.sideBarViewController = sideBarViewController
    
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
    
    viewModel.updateBoardDetailCollectionView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    configureSideBarView()
  }
  
  
  // MARK: - Method
  
  private func updatePageControlNumber(to numbers: Int) {
    pageControl.numberOfPages = numbers
  }
}


// MARK: - Extension Configure Method

private extension BoardDetailViewController {
  
  func configure() {
    view.addSubview(pageControl)
    
    configurePageControl()
    configureNavigationBar()
    configureCollectionView()
  }
  
  func configurePageControl() {
    NSLayoutConstraint.activate([
      pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
      pageControl.heightAnchor.constraint(equalToConstant: 10)
    ])
  }
  
  func configureNavigationBar() {
    navigationItem.largeTitleDisplayMode = .never
    guard let navigationBar = navigationController?.navigationBar else { return }
    
    configureNavigationBarAppearance(of: navigationBar)
    configureNavigationBarTitleView(of: navigationBar)
    configureBarButtonItem()
  }
  
  func configureNavigationBarAppearance(of navigationBar: UINavigationBar) {
    let navigationAppearance = UINavigationBarAppearance()
    navigationAppearance.configureWithTransparentBackground()
    navigationAppearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterialDark)
    navigationBar.standardAppearance = navigationAppearance
  }
  
  func configureNavigationBarTitleView(of navigationBar: UINavigationBar) {
    let frame = CGRect(
      x: 0,
      y: 0,
      width: navigationBar.frame.size.width,
      height: navigationBar.frame.size.height
    )
    titleTextField.frame = frame
    navigationItem.titleView = titleTextField
  }
  
  func configureBarButtonItem() {
    navigationItem.leftBarButtonItem = CustomBarButtonItem(imageName: "xmark") { [weak self] in
      self?.coordinator?.pop()
    }
    navigationItem.rightBarButtonItem = CustomBarButtonItem(imageName: "ellipsis" ) { [weak self] in
      self?.sideBarViewController.expandSideBar()
    }
  }
  
  func configureCollectionView() {
    let flowLayout = UICollectionViewFlowLayout()
    
    let sectionSpacing: CGFloat = 25
    flowLayout.sectionInset = UIEdgeInsets(top: 0, left: sectionSpacing, bottom: 0, right: 0)
    flowLayout.scrollDirection = .horizontal
    
    flowLayout.itemSize = CGSize(
      width: view.bounds.width - (sectionSpacing * 2),
      height: view.bounds.height * 0.8
    )
    
    scrollOffset = (flowLayout.sectionInset.left
                      + flowLayout.itemSize.width
                      + flowLayout.minimumLineSpacing
                      + flowLayout.itemSize.width/2) - (view.bounds.width/2)
    
    flowLayout.footerReferenceSize = CGSize(
      width: flowLayout.minimumLineSpacing + flowLayout.itemSize.width + flowLayout.sectionInset.left,
      height: 80
    )
    collectionView.collectionViewLayout = flowLayout
  }
  
  func configureSideBarView() {
    let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
    let topBarHeight = statusBarHeight + navigationBarHeight
    
    let sideBarView = sideBarViewController.view()
    sideBarView.frame = CGRect(
      x: 0,
      y: 0,
      width: view.bounds.width,
      height: view.bounds.height
    )
    
    view.addSubview(sideBarViewController.view())
    
    sideBarViewController.configureTopHeight(to: topBarHeight)
    sideBarViewController.start()
  }
}

// MARK: - Extension UICollectionViewDataSource

extension BoardDetailViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let numberOfPages = viewModel.numberOfLists()
    updatePageControlNumber(to: numberOfPages)
    
    return numberOfPages
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: BoardDetailCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    
    guard let list = viewModel.fetchList(at: indexPath.item)
    else { return UICollectionViewCell() }
    
    let viewModel = ListViewModel(list: list)
    
    cell.update(with: viewModel)
    return cell
  }
}


// MARK: - Extension UICollectionViewDelegate

extension BoardDetailViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let footerView: BoardDetailFooterView = collectionView.dequeReusableFooterView(forIndexPath: indexPath)
    
    // TODO: 추후 수정 예정
    footerView.addHandler = { [weak self] text in
      self?.viewModel.insertList(list: List(id: 4, title: text, position: 0, cards: []))
      self?.collectionView.reloadSections(IndexSet(integer: 0))
      self?.pageControl.currentPage += 1
    }
    return footerView
  }
}


// MARK: - Extension UICollectionView Scroll

extension BoardDetailViewController {
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let index = scrollView.contentOffset.x / scrollOffset
    
    var renewedIndex: CGFloat
    if scrollView.contentOffset.x > targetContentOffset.pointee.x {
      renewedIndex = floor(index) // 왼쪽
    } else {
      renewedIndex = ceil(index)  // 오른쪽
    }
    
    targetContentOffset.pointee = CGPoint(x: renewedIndex * scrollOffset, y: 0)
    pageControl.currentPage = Int(renewedIndex)
  }
}


// MARK: - Extension UITextField Delegate

extension BoardDetailViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let title = textField.text {
      viewModel.updateBoardTitle(to: title)
    }
    textField.resignFirstResponder()
    return false
  }
}


// MARK: - Extension bindUI

private extension BoardDetailViewController {
  
  func bindUI() {
    viewModel.bindingUpdateBoardDetailCollectionView { [weak self] in
      DispatchQueue.main.async {
        self?.collectionView.reloadData()
      }
    }
    
    viewModel.bindingUpdateBackgroundColor { [weak self] colorString in
      DispatchQueue.main.async {
        self?.view.backgroundColor = colorString.toUIColor()
      }
    }
    
    viewModel.bindingUpdateBoardTitle { [weak self] title in
      DispatchQueue.main.async {
        self?.titleTextField.text = title
      }
    }
  }
}
