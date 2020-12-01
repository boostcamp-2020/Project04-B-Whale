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
  
  @IBOutlet private weak var collectionView: UICollectionView!
  private let pageControl: UIPageControl = {
    let pageControl = UIPageControl()
    
    pageControl.numberOfPages = 7
    
    return pageControl
  }()
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder, viewModel: BoardDetailViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    bindUI()
    configure()
  }
}

// MARK: - Extension

extension BoardDetailViewController {
  
  func bindUI() {
    
  }
  
  func configure() {
    navigationItem.largeTitleDisplayMode = .never
    view.backgroundColor = #colorLiteral(red: 0.3077110052, green: 0.5931787491, blue: 0.2305498123, alpha: 1)
    
    view.addSubview(pageControl)
    
    configureNavigationBar()
    configureCollectionView()
    configurePageControl()
  }
  
  func configureNavigationBar() {
    
    let navigationAppearance = UINavigationBarAppearance()
    navigationAppearance.configureWithTransparentBackground()
    navigationAppearance.backgroundEffect = UIBlurEffect(style: .dark)
    navigationController?.navigationBar.standardAppearance = navigationAppearance
    
    navigationItem.leftBarButtonItem = CustomBarButtonItem(imageName: "xmark") { [weak self] in
      self?.coordinator?.pop()
    }
    navigationItem.rightBarButtonItem = CustomBarButtonItem(imageName: "ellipsis" ) { [weak self] in
      
    }
    
  }
  
  func configureCollectionView() {
    collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    collectionView.backgroundColor = .clear
    
    collectionView.dataSource = self
    collectionView.delegate = self
    
    let flowLayout = UICollectionViewFlowLayout()
    
    let sectionSpacing: CGFloat = 25
    flowLayout.sectionInset = UIEdgeInsets(top: 0, left: sectionSpacing, bottom: 0, right: sectionSpacing)
    flowLayout.scrollDirection = .horizontal
    flowLayout.itemSize = CGSize(
      width: view.bounds.width - (sectionSpacing * 2),
      height: view.bounds.height * 0.8
    )
    
    collectionView.collectionViewLayout = flowLayout
    collectionView.showsHorizontalScrollIndicator = false
    
    collectionView.register(BoardDetailCollectionViewCell.self)
  }
  
  func configurePageControl() {
    
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
      pageControl.heightAnchor.constraint(equalToConstant: 10)
    ])
  }
}

extension BoardDetailViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfLists()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: BoardDetailCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    
    let list = viewModel.fetchList(at: indexPath.item)
    let viewModel = ListViewModel(list: list)
    
    cell.update(with: viewModel)
    return cell
  }
}

extension BoardDetailViewController: UICollectionViewDelegate {
  
}

extension BoardDetailViewController {
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

    let offset = (
      layout.sectionInset.left
        + layout.itemSize.width
        + layout.minimumLineSpacing
        + layout.itemSize.width/2
    ) - (view.bounds.width/2)

    let index = scrollView.contentOffset.x / offset

    var renewedIndex: CGFloat
    if scrollView.contentOffset.x > targetContentOffset.pointee.x {
      renewedIndex = floor(index) // 왼쪽
    } else {
      renewedIndex = ceil(index)  // 오른쪽
    }

    targetContentOffset.pointee = CGPoint(x: renewedIndex * offset, y: 0)
    pageControl.currentPage = Int(renewedIndex)
  }
}