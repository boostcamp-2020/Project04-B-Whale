//
//  SideBarView.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/01.
//

import UIKit

protocol SideBarViewDelegate: AnyObject {
  
  func boardDeleteButtonTapped()
  func successBoardDelete(confirmAction: @escaping () -> Void)
}


final class SideBarView: UIView {
  
  // MARK: - Property
  
  private let viewModel: SideBarViewModelProtocol

  private lazy var titleView: ImageTitleView = {
    let view = ImageTitleView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    view.backgroundColor = #colorLiteral(red: 0.998553474, green: 1, blue: 0.9636932791, alpha: 1)
    view.update(withImageName: "info.circle", andTitle: "정보")
    
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
    let image = UIImage(named: "exit-icon")
    button.setImage(image, for: .normal)
    button.tintColor = .red
    
    return button
  }()
  
  weak var delegate: SideBarViewDelegate?
  
  
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
    fatalError("The class should be initialized with code")
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
    
    addingTarget()
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
  }
  
  func configureExitButton() {
    NSLayoutConstraint.activate([
      exitButton.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -15),
      exitButton.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 10),
      exitButton.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -10),
      exitButton.widthAnchor.constraint(equalTo: exitButton.heightAnchor)
    ])
  }
  
  func addingTarget() {
    exitButton.addTarget(self, action: #selector(boardDeleteButtonTapped), for: .touchUpInside)
  }
}


// MARK: - Extension UIBind

private extension SideBarView {
  
  func bindUI() {
    bindingUpdateSideBarCollectionView()
    bindingShowExitButton()
    bindindAfterDeleteBoardAction()
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
  
  func bindindAfterDeleteBoardAction() {
    viewModel.bindindAfterDeleteBoardAction { [weak self] in
      DispatchQueue.main.async {
        self?.delegate?.boardDeleteButtonTapped()
      }
    }
  }
}


// MARK:- Extension objc Method

extension SideBarView {
  
  @objc private func boardDeleteButtonTapped() {
    delegate?.successBoardDelete { [weak self] in
      self?.viewModel.deleteBoard()
    }
  }
}
