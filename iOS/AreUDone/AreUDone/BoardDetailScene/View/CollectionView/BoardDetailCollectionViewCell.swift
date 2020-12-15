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
  private var dataSource: UITableViewDataSource!
  private var presentCardDetailHandler: ((Int) -> Void)?
  private var presentCardAddHandler: ((ListViewModelProtocol) -> Void)?
    
  private lazy var tableView: UITableView = {
    let tableView = UITableView(frame: bounds, style: .plain)
    
    tableView.backgroundColor = .clear
    tableView.register(ListTableViewCell.self)
    tableView.rowHeight = 55
    tableView.sectionHeaderHeight = 60
    tableView.sectionFooterHeight = 60
    
    tableView.delegate = self
    
    return tableView
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
  
  
  // MARK: - Method
  
  func update(
    with viewModel: ListViewModelProtocol,
    dataSource: UITableViewDataSource,
    presentCardDetailHandler: ((Int) -> Void)?,
    presentCardAddHandler: ((ListViewModelProtocol) -> Void)? = nil
  ) {
    self.viewModel = viewModel
    self.dataSource = dataSource
    self.presentCardDetailHandler = presentCardDetailHandler
    self.presentCardAddHandler = presentCardAddHandler
    
    tableView.dataSource = self.dataSource
    tableView.dropDelegate = self

    bindUI()
    viewModel.updateTableView()
  }
}


// MARK: - Extension Configure Method

private extension BoardDetailCollectionViewCell {
  
  func configure() {
    addSubview(tableView)
    
    configureCollectionView()
    configureNotification()
  }
  
  func configureCollectionView() {
    tableView.dragInteractionEnabled = true
    tableView.dragDelegate = self
    tableView.dropDelegate = self
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: topAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }
  
  func configureNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(listWillDragged), name: Notification.Name.listWillDragged, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(listDidDragged), name: Notification.Name.listDidDragged, object: nil)
  }
}


// MARK: - Extension UITableView Delegate

extension BoardDetailCollectionViewCell: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cardId = viewModel.fetchCard(at: indexPath.item).id
    presentCardDetailHandler?(cardId)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = ListHeaderView()
    headerView.update(with: viewModel)
    return headerView
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let footerView = ListFooterView()
    footerView.delegate = self
    
    return footerView
  }
}


// MARK: - Extension ListFooterView Delegate

extension BoardDetailCollectionViewCell: ListFooterViewDelegate {

  func baseViewTapped() {
    presentCardAddHandler?(viewModel)
  }
}



// MARK: - Extension UITableView Drag Delegate

extension BoardDetailCollectionViewCell: UITableViewDragDelegate {
  
  func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    let card = viewModel.fetchCard(at: indexPath.row)
    let itemProvider = NSItemProvider(object: card)
    
    let dragItem = UIDragItem(itemProvider: itemProvider)
    
    session.localContext = (viewModel, indexPath, tableView)
    return [dragItem]
  }
}


// MARK: - Extension UITableView Drop Delegate

extension BoardDetailCollectionViewCell: UITableViewDropDelegate {
  
  func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
    if !session.hasItemsConforming(toTypeIdentifiers: [kUTTypeData as String]) {
      tableView.dropDelegate = nil
    }
    return session.hasItemsConforming(toTypeIdentifiers: [kUTTypeData as String])
  }
  
  func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
    return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
  }
  
  func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    guard coordinator.session.hasItemsConforming(
            toTypeIdentifiers: [kUTTypeItem as String])
    else { return }
    
    processDraggedItem(by: tableView, and: coordinator)
  }

  private func processDraggedItem(by tableView: UITableView, and coordinator: UITableViewDropCoordinator) {
    
    coordinator.session.loadObjects(ofClass: Card.self) { [self] item in
      guard let card = item.first as? Card else { return }
      
      let source = coordinator.items.first?.sourceIndexPath
      let destination = coordinator.destinationIndexPath
      
      switch (source, destination) {
      ///  ** 1. 같은 테이블뷰**
      case (.some(let sourceIndexPath), .some(let destinationIndexPath)):
        
        viewModel.updateCardPosition(from: sourceIndexPath.row, to: destinationIndexPath.row, by: card) {
          DispatchQueue.main.async {
            tableView.beginUpdates()
            tableView.deleteRows(at: [IndexPath(item: sourceIndexPath.row, section: 0)], with: .left)
            tableView.insertRows(at: [IndexPath(item: destinationIndexPath.row, section: 0)], with: .right)
            
            tableView.endUpdates()
            
          }
        }
        
      /// **2. 다른 테이블뷰: cell 을 밀어내고 삽입할 때**
      case (nil, .some(let destinationIndexPath)):
        guard let (
                sourceViewModel,
                sourceIndexPath,
                sourceTableView) = coordinator.session.localDragSession?.localContext
                as? (
                  ListViewModelProtocol,
                  IndexPath,
                  UITableView
                ) else { return }
        
        viewModel.updateCardPosition(from: sourceIndexPath.item, to: destinationIndexPath.row, by: card, in: sourceViewModel) {
          DispatchQueue.main.async {
            if sourceTableView != tableView {
              sourceTableView.reloadData()
            }

            let index = destinationIndexPath.item
            tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .right)
          }
        }
        
      /// **3. 다른 테이블뷰: cell 을 밀어내지 않고 삽입할 때**
      case (.some(_), nil):
        fallthrough
        
      case (nil, nil):
        guard let (
                sourceViewModel,
                sourceIndexPath,
                sourceTableView) = coordinator.session.localDragSession?.localContext
                as? (
                  ListViewModelProtocol,
                  IndexPath,
                  UITableView
                ) else { return }
        
        viewModel.updateCardPosition(from: sourceIndexPath.row, by: card, in: sourceViewModel) { lastIndex in
          DispatchQueue.main.async {
            if sourceTableView != tableView {
              sourceTableView.reloadData()
            }
            tableView.insertRows(at: [IndexPath(item: lastIndex, section: 0)], with: .right)
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
    tableView.dropDelegate = nil
    isDroppable = false
  }
  @objc func listDidDragged() {
    tableView.dropDelegate = self
    isDroppable = true
  }
}


// MARK: - Extension bindUI

private extension BoardDetailCollectionViewCell {
  
  func bindUI() {
    viewModel.bindingUpdateCollectionView { [weak self] in
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }
  }
}

