//
//  CardDetailMemberView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/07.
//

import UIKit

protocol CardDetailMemberViewDelegate: NSObject {
  func cardDetailMemberEditButtonTapped()
}

final class CardDetailMemberView: UIView {
  
  // TODO:- 위치변경, Item 변경
  typealias DataSource = UICollectionViewDiffableDataSource<Section, CardDetail.Member>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, CardDetail.Member>
  
  // MARK:- Property
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "멤버"
    label.font = UIFont.nanumB(size: 20)
    
    return label
  }()
  
  private lazy var editButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(systemName: "person.crop.circle.badge.plus")
    button.setImage(image, for: .normal)
    
    return button
  }()
  
  private lazy var memberCollectionView: CardDetailMemberCollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    let collectionView = CardDetailMemberCollectionView(
      frame: CGRect.zero,
      collectionViewLayout: flowLayout
    )
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    return collectionView
  }()
  
  private lazy var dataSource = configureDataSource()
  private let viewModel: CardDetailViewModelProtocol
  weak var delegate: CardDetailMemberViewDelegate?
  
  // MARK:- Initializer
  
  init(viewModel: CardDetailViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(frame: CGRect.zero)
    
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("This view should be initialized with code")
  }
  
  func update(with members: [CardDetail.Member]) {
    applySnapshot(with: members, animatingDifferences: false)
  }
}


// MARK:- Extension Configure Method

private extension CardDetailMemberView {
  
  func configure() {
    layer.borderWidth = 0.3
    layer.borderColor = UIColor.lightGray.cgColor
    
    addSubview(titleLabel)
    addSubview(memberCollectionView)
    addSubview(editButton)
    
    configureTitleLabel()
    configureMemberCollectionView()
    configureEditButton()
    
    addingTarget()
  }
  
  func configureTitleLabel() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
    ])
  }
  
  func configureMemberCollectionView() {
    NSLayoutConstraint.activate([
      memberCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
      memberCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
      memberCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
      memberCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
    ])
  }
  
  func configureEditButton() {
    NSLayoutConstraint.activate([
      editButton.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
      editButton.widthAnchor.constraint(equalTo: editButton.heightAnchor),
      editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
      editButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
    ])
  }
  
  func configureDataSource() -> DataSource {
    let dataSource = DataSource(
      collectionView: memberCollectionView
    ) { [weak self] collectionView, indexPath, member -> UICollectionViewCell? in
      let cell: CardDetailMemberCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      
      self?.viewModel.fetchProfileImage(with: member.profileImageUrl) { data in
        let image = UIImage(data: data)
        cell.update(with: image)
      }
      
      return cell
    }
    
    return dataSource
  }
  
  func applySnapshot(with members: [CardDetail.Member], animatingDifferences: Bool = true) {
    var snapshot = Snapshot()
    
    snapshot.appendSections([.main])
    snapshot.appendItems(members)
    
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }
  
  func addingTarget() {
    editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
  }
}


private extension CardDetailMemberView {
  
  @objc private func editButtonTapped() {
    delegate?.cardDetailMemberEditButtonTapped()
  }
}
