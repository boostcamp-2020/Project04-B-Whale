//
//  SideBarView.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/01.
//

import UIKit

final class SideBarView: UIView {
  
  // MARK: - Property
  
  private let viewModel: SideBarViewModelProtocol

  private lazy var titleView: ImageTitleView = {
    let view = ImageTitleView()
    view.update(withImageName: "info.circle", andTitle: "정보")
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = #colorLiteral(red: 0.998553474, green: 1, blue: 0.9636932791, alpha: 1)
    
    return view
  }()
  private lazy var collectionView: SideBarCollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    let collectionView = SideBarCollectionView(frame: frame, collectionViewLayout: flowLayout)
        
    return collectionView
  }()

  private lazy var exitButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(systemName: "trash.fill")
    button.setImage(image, for: .normal)
    
    return button
  }()
  
  
  // MARK: - Initializer
  
  init(
    frame: CGRect,
    viewModel: SideBarViewModelProtocol,
    dataSource: UICollectionViewDataSource
  ) {
    self.viewModel = viewModel
    
    super.init(frame: frame)
    
    configure()
    bindUI()
    collectionView.dataSource = dataSource
  }
  
  required init?(coder: NSCoder) {
    fatalError("The class should initialized with code")
  }
}


// MARK: - Extension Configure Method

private extension SideBarView {
  
  func configure() {
    addSubview(titleView)
    addSubview(collectionView)
    titleView.addSubview(exitButton)
    
    configureView()
    configureTitleView()
    configureCollectionView()
    configureExitButton()
  }
  
  func configureView() {
    backgroundColor = .white

    layer.cornerRadius = 10
    layer.masksToBounds = true
    layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
  }
  
  func configureTitleView() {
    NSLayoutConstraint.activate([
      titleView.topAnchor.constraint(equalTo: topAnchor),
      titleView.leadingAnchor.constraint(equalTo: leadingAnchor),
      titleView.trailingAnchor.constraint(equalTo: trailingAnchor),
      titleView.heightAnchor.constraint(equalToConstant: 40)
    ])
  }
  
  func configureCollectionView() {
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
    
    viewModel.updateCollectionView()
  }
  
  func configureExitButton() {
    NSLayoutConstraint.activate([
      exitButton.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -10),
      exitButton.topAnchor.constraint(equalTo: titleView.topAnchor),
      exitButton.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
      exitButton.widthAnchor.constraint(equalTo: exitButton.heightAnchor)
    ])
  }
}


// MARK: - Extension UIBind

private extension SideBarView {
  
  func bindUI() {
    bindingUpdateSideBarCollectionView()
    bindingShowExitButton()
  }
  
  func bindingUpdateSideBarCollectionView() {
    viewModel.bindingUpdateSideBarCollectionView { [weak self] in
      DispatchQueue.main.async {
          self?.collectionView.reloadData()
      }
    }
  }
  
  func bindingShowExitButton() {
    viewModel.bindingShowExitButton { [weak self] isCreator in
      DispatchQueue.main.async {
        self?.exitButton.isHidden = !isCreator
      }
    }
  }
}
