//
//  BoardDetailCollectionViewCell.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import UIKit
import MobileCoreServices

final class BoardDetailCollectionViewCell: UICollectionViewCell, Reusable {
  
  // MARK: - Property
  
  private var viewModel: ListViewModelProtocol!
  private var dataSource: UICollectionViewDataSource!
  
  private lazy var collectionView: ListCollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    
    let collectionView = ListCollectionView(frame: bounds, collectionViewLayout: flowLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.contentInset = UIEdgeInsets.sameInset(inset: 5)
    
    return collectionView
  }()
  private var isDroppable: Bool = true
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    collectionView.reloadData()
  }
  
  // MARK: - Method
  
  func update(
    with viewModel: ListViewModelProtocol,
    dataSource: UICollectionViewDataSource
  ) {
    self.viewModel = viewModel
    self.dataSource = dataSource
    collectionView.dataSource = dataSource

    bindUI()
    viewModel.updateCollectionView()
  }
}

private extension BoardDetailCollectionViewCell {
  
  func bindUI() {
    viewModel.bindingUpdateCollectionView { [weak self] in
      DispatchQueue.main.async {
        self?.collectionView.reloadData()
      }
    }
  }
}


// MARK: - Extension Configure Method

private extension BoardDetailCollectionViewCell {
  
  func configure() {
    addSubview(collectionView)
    
    configureCollectionView()
    configureNotification()
  }
  
  func configureCollectionView() {
    collectionView.delegate = self
    collectionView.dragInteractionEnabled = true
    collectionView.dragDelegate = self
    collectionView.dropDelegate = self
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }
  
  func configureNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(listWillDragged), name: Notification.Name.listWillDragged, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(listDidDragged), name: Notification.Name.listDidDragged, object: nil)
  }
}


// MARK: - Extension UICollectionView Delegate

extension BoardDetailCollectionViewCell: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // TODO: 카드 id 얻어서 카드 상세화면으로 넘어가는 로직 필요(viewmodel에게 물어보면 될듯함)
    
  }
}


// MARK: - Extension UICollectionView Drag Delegate

extension BoardDetailCollectionViewCell: UICollectionViewDragDelegate {
  
  // 1. 드래깅 시작
  func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    let card = viewModel.fetchCard(at: indexPath.item)
    let itemProvider = NSItemProvider(object: card)
    
    let dragItem = UIDragItem(itemProvider: itemProvider)
    
    session.localContext = (viewModel, indexPath, collectionView)
    return [dragItem]
  }
}


// MARK: - Extension UICollectionView Drop Delegate

extension BoardDetailCollectionViewCell: UICollectionViewDropDelegate {
  
  func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
    
    
    return isDroppable
  }
  
  // 2. 드래깅 중
  func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
    return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
  }
  
  // 3. 드래깅 끝
  func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    guard coordinator.session.hasItemsConforming(
            toTypeIdentifiers: [kUTTypeData as String])
    else { return }
    
    processDraggedItem(by: collectionView, and: coordinator)
  }
  
  private func processDraggedItem(by collectionView: UICollectionView, and coordinator: UICollectionViewDropCoordinator) {
    
    // 드래그한 아이템의 객체를 비동기적으로 로드
    coordinator.session.loadObjects(ofClass: Card.self) { [self] item in
      guard let card = item.first as? Card else { return }
      
      let source = coordinator.items.first?.sourceIndexPath
      let destination = coordinator.destinationIndexPath
      
      switch (source, destination) {
      ///  ** 1. 같은 컬렉션뷰**
      case (.some(let sourceIndexPath), .some(let destinationIndexPath)):
        
        viewModel.updateCardPosition(from: sourceIndexPath.item, to: destinationIndexPath.item, by: card) {
          DispatchQueue.main.async {
            collectionView.performBatchUpdates {
              collectionView.deleteItems(at: [IndexPath(item: sourceIndexPath.item, section: 0)])
              collectionView.insertItems(at: [IndexPath(item: destinationIndexPath.item, section: 0)])
            }
          }
        }
        
      /// **2. 다른 컬렉션뷰: cell 을 밀어내고 삽입할 때**
      case (nil, .some(let destinationIndexPath)):
        guard let (
                sourceViewModel,
                sourceIndexPath,
                sourceCollectionView) = coordinator.session.localDragSession?.localContext
                as? (
                  ListViewModelProtocol,
                  IndexPath,
                  UICollectionView
                ) else { return }
        
        viewModel.updateCardPosition(from: sourceIndexPath.item, to: destinationIndexPath.item, by: card, in: sourceViewModel) {
          DispatchQueue.main.async {
            sourceCollectionView.deleteItems(at: [IndexPath(item: sourceIndexPath.item, section: 0)])
            
            let index = destinationIndexPath.item
            collectionView.insertItems(at: [IndexPath(item: index, section: 0)])
          }
        }
        
      /// **3. 다른 컬렉션뷰: cell 을 밀어내지 않고 삽입할 때**
      case (.some(_), nil):
        fallthrough
        
      case (nil, nil):
        guard let (
                sourceViewModel,
                sourceIndexPath,
                sourceCollectionView) = coordinator.session.localDragSession?.localContext
                as? (
                  ListViewModelProtocol,
                  IndexPath,
                  UICollectionView
                ) else { return }
        
        viewModel.updateCardPosition(from: sourceIndexPath.item, by: card, in: sourceViewModel) { lastIndex in
          DispatchQueue.main.async {
            sourceCollectionView.deleteItems(at: [IndexPath(item: sourceIndexPath.item, section: 0)])
            
            collectionView.insertItems(at: [IndexPath(item: lastIndex, section: 0)])
          }
        }
        
        break
      }
    }
  }
}


// MARK: - Extension objc

extension BoardDetailCollectionViewCell {
  
  @objc func listWillDragged() {
    isDroppable = false
  }
  @objc func listDidDragged() {
    isDroppable = true
  }
}
