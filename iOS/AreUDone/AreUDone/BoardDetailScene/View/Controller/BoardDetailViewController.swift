//
//  BoardDetailViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import UIKit
import MobileCoreServices

final class BoardDetailViewController: UIViewController {
  
  // MARK: - Property
  
  private let viewModel: BoardDetailViewModelProtocol
  private let sideBarViewController: SideBarViewControllerProtocol
  
  private lazy var titleTextField: UITextField = {
    let textField = UITextField()
    
    textField.delegate = self
    textField.returnKeyType = .done
    textField.textColor = .white
    textField.font = UIFont.nanumB(size: 19)
    
    return textField
  }()
  @IBOutlet private weak var collectionView: BoardDetailCollectionView! {
    didSet {
      collectionView.dataSource = dataSource
      collectionView.delegate = self
      
      collectionView.dragInteractionEnabled = true
      collectionView.dragDelegate = self
      collectionView.dropDelegate = self
    }
  }
  private lazy var refreshView: RefreshView = {
    let view = RefreshView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  private lazy var pageControl: UIPageControl = {
    let pageControl = UIPageControl()
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    
    return pageControl
  }()
  
  weak var coordinator: BoardDetailCoordinator?
  private lazy var dataSource = BoardDetailCollectionViewDataSource(
    viewModel: viewModel,
    presentCardAddHandler: { [weak self] viewModel in
      self?.coordinator?.presentCardAdd(to: viewModel)
    }, presentCardDetailHandler: { [weak self] cardId in
      self?.coordinator?.pushCardDetail(of: cardId)
    })
  private var firstScrollOffset: CGFloat!
  private var scrollOffset: CGFloat!
  
  
  
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
    fatalError("This controller should be initialized with code")
  }
  
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindUI()
    configure()
    
    viewModel.fetchBoardDetail()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    configureSideBarView()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    viewModel.save()
  }
}


// MARK: - Extension Configure Method

private extension BoardDetailViewController {
  
  func configure() {
    view.addSubview(pageControl)
    view.addSubview(refreshView)
    
    configureNotification()
    configurePageControl()
    configureNavigationBar()
    configureCollectionView()
    configureRefreshView()
    
    addingGestureRecognizer()
  }
  
  func configureNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(cardWillDragged),
      name: Notification.Name.cardWillDragged,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self, selector: #selector(cardDidDragged),
      name: Notification.Name.cardDidDragged,
      object: nil
    )
  }
  
  func configurePageControl() {
    NSLayoutConstraint.activate([
      pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
      pageControl.heightAnchor.constraint(equalToConstant: 10)
    ])
  }
  
  func configureNavigationBar() {
    navigationController?.isNavigationBarHidden = false
    navigationItem.largeTitleDisplayMode = .never
    
    guard let navigationBar = navigationController?.navigationBar else { return }
    configureNavigationBarAppearance(of: navigationBar)
    configureNavigationBarTitleView(of: navigationBar)
    
    configureBarButtonItem()
  }
  
  func configureNavigationBarAppearance(of navigationBar: UINavigationBar) {
    let navigationAppearance = UINavigationBarAppearance()
    let font = UIFont.nanumB(size: 16)
    navigationAppearance.titleTextAttributes = [NSAttributedString.Key.font: font]
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
      width: view.bounds.width * 0.8 - (sectionSpacing * 2),
      height: view.bounds.height * 0.8
    )
    
    firstScrollOffset = (flowLayout.sectionInset.left
                          + flowLayout.itemSize.width
                          + flowLayout.minimumLineSpacing
                          + flowLayout.itemSize.width/2) - (view.bounds.width/2)
    scrollOffset = flowLayout.itemSize.width + flowLayout.minimumLineSpacing
    
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
  
  func configureRefreshView() {
    NSLayoutConstraint.activate([
      refreshView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.1),
      refreshView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height * 0.1),
      refreshView.heightAnchor.constraint(equalToConstant: 50),
      refreshView.widthAnchor.constraint(equalToConstant: 50)
    ])
  }
  
  func addingGestureRecognizer() {
    let tapGestureRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(refreshButtonTapped)
    )
    refreshView.addGestureRecognizer(tapGestureRecognizer)
  }
}


// MARK: - Extension BindUI

private extension BoardDetailViewController {
  
  func bindUI() {
    bindingUpdateBoardDetailCollectionView()
    bindingUpdateBackgroundColor()
    bindingUpdateBoardTitle()
    bindingUpdateControlPageCounts()
  }
  
  func bindingUpdateBoardDetailCollectionView() {
    viewModel.bindingUpdateBoardDetailCollectionView { [weak self] in
      DispatchQueue.main.async {
        self?.collectionView.reloadData()
      }
    }
  }
  
  func bindingUpdateBackgroundColor() {
    viewModel.bindingUpdateBackgroundColor { [weak self] colorString in
      DispatchQueue.main.async {
        self?.view.backgroundColor = colorString.toUIColor()
      }
    }
  }
  
  func bindingUpdateBoardTitle() {
    viewModel.bindingUpdateBoardTitle { [weak self] title in
      DispatchQueue.main.async {
        self?.titleTextField.text = title
      }
    }
  }
  
  func bindingUpdateControlPageCounts() {
    viewModel.bindingUpdateControlPageCounts { [weak self] counts in
      DispatchQueue.main.async {
        self?.pageControl.numberOfPages = counts
      }
    }
  }
}


// MARK: - Extension UICollectionView Scroll / Delegate

extension BoardDetailViewController: UICollectionViewDelegate {
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    var renewedIndex: CGFloat
    var expectedX: CGFloat
    
    if scrollView.contentOffset.x < firstScrollOffset {
      let index = scrollView.contentOffset.x / scrollOffset
      
      renewedIndex = makeRenewedIndex(
        with: index,
        currentX: scrollView.contentOffset.x,
        targetX: targetContentOffset.pointee.x
      )
      expectedX = renewedIndex * firstScrollOffset
      
    } else {
      let index = (scrollView.contentOffset.x - firstScrollOffset) / scrollOffset
      renewedIndex = makeRenewedIndex(
        with: index,
        currentX: scrollView.contentOffset.x,
        targetX: targetContentOffset.pointee.x
      )
      expectedX = renewedIndex * scrollOffset + firstScrollOffset
      renewedIndex += 1
    }
    
    targetContentOffset.pointee = CGPoint(x: expectedX, y: 0)
    pageControl.currentPage = Int(renewedIndex)
  }
  
  func makeRenewedIndex(with index: CGFloat, currentX: CGFloat, targetX: CGFloat) -> CGFloat {
    var renewedIndex: CGFloat
    
    if currentX > targetX {
      renewedIndex = floor(index) // 왼쪽
    } else {
      renewedIndex = ceil(index)  // 오른쪽
    }
    return renewedIndex
  }
}


// MARK: - Extension UICollectionView Drag Delegate

extension BoardDetailViewController: UICollectionViewDragDelegate {
  
  func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    guard let list = viewModel.fetchList(at: indexPath.item) else { return [] }
    
    let itemProvider = NSItemProvider(object: list)
    let dragItem = UIDragItem(itemProvider: itemProvider)
    
    return [dragItem]
  }
  
  func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
    NotificationCenter.default.post(name: Notification.Name.listWillDragged, object: nil)
    
  }
  
  func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
    NotificationCenter.default.post(name: Notification.Name.listDidDragged, object: nil)
  }
}


// MARK: - Extension UICollectionView Drop Delegate

extension BoardDetailViewController: UICollectionViewDropDelegate {
  
  func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
    return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
  }
  
  func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    guard coordinator.session.hasItemsConforming(
            toTypeIdentifiers: [kUTTypeDirectory as String])
    else { return }
    
    processDraggedItem(by: collectionView, and: coordinator)
  }
  
  private func processDraggedItem(by collectionView: UICollectionView, and coordinator: UICollectionViewDropCoordinator) {
    
    coordinator.session.loadObjects(ofClass: ListOfBoard.self) { [self] item in
      guard let list = item.first as? ListOfBoard else { return }
      
      guard let source = coordinator.items.first?.sourceIndexPath,
            let destination = coordinator.destinationIndexPath
      else { return }
      
      viewModel.updatePosition(of: source.item, to: destination.item, list: list) {
        DispatchQueue.main.async {
          collectionView.performBatchUpdates {
            collectionView.deleteItems(at: [IndexPath(item: source.item, section: 0)])
            collectionView.insertItems(at: [IndexPath(item: destination.item, section: 0)])
          }
        }
      }
    }
  }
}


// MARK: - Extension UITextField Delegate

extension BoardDetailViewController: UITextFieldDelegate {
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if let title = textField.text {
      viewModel.updateBoardTitle(to: title)
    }
    textField.resignFirstResponder()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
}


// MARK: - Extension objc Method

extension BoardDetailViewController {
  
  @objc func cardWillDragged() {
    collectionView.dropDelegate = nil
  }
  
  @objc func cardDidDragged() {
    collectionView.dropDelegate = self
  }
  
  @objc func refreshButtonTapped() {
    viewModel.fetchBoardDetail()
    refreshView.rotateRefreshImage(forCount: 2)
  }
}
