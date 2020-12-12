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
  weak var coordinator: BoardDetailCoordinator?
  private lazy var dataSource = BoardDetailCollectionViewDataSource(viewModel: viewModel) { [weak self] viewModel in
    self?.coordinator?.presentCardAdd(to: viewModel)
  }
  
  private lazy var titleTextField: UITextField = {
    let textField = UITextField()
    
    textField.delegate = self
    textField.returnKeyType = .done
    textField.textColor = .white
    
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
  private let pageControl: UIPageControl = {
    let pageControl = UIPageControl()
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    
    return pageControl
  }()
  private var firstScrollOffset: CGFloat!
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
    
    viewModel.fetchBoardDetail()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    configureSideBarView()
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
    navigationController?.isNavigationBarHidden = false
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
  
  // 1. 드래깅 시작
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
    return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
  }
  
  func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    guard coordinator.session.hasItemsConforming(
            toTypeIdentifiers: [kUTTypeData as String])
    else { return }
    
    processDraggedItem(by: collectionView, and: coordinator)
  }
  
  private func processDraggedItem(by collectionView: UICollectionView, and coordinator: UICollectionViewDropCoordinator) {
    
    coordinator.session.loadObjects(ofClass: List.self) { [self] item in
      guard let list = item.first as? List else { return }
      
      guard let source = coordinator.items.first?.sourceIndexPath,
            let destination = coordinator.destinationIndexPath
      else { return }
     
      viewModel.updatePosition(of: source.item, to: destination.item, list: list) {
        DispatchQueue.main.async {
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
    
    viewModel.bindingUpdateControlPageCounts { [weak self] counts in
      DispatchQueue.main.async {
        self?.pageControl.numberOfPages = counts
      }
    }
  }
}
