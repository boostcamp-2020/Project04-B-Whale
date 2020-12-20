//
//  SideBarViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/01.
//

import UIKit

protocol SideBarViewControllerProtocol: AnyObject {
  
  func pushInvitation()
  
  func start()
  func configureTopHeight(to topHeight: CGFloat)
  func view() -> UIView
  func expandSideBar()
}

final class SideBarViewController: UIViewController {
  
  // MARK: - Enum
  
  enum SideBarState {
    case collapsed
    case expanded
  }
  
  
  // MARK: - Property
  
  private let viewModel: SideBarViewModelProtocol
  private weak var coordinator: BoardDetailCoordinator?

  private lazy var sideBarDataSource: UICollectionViewDataSource = SideBarCollectionViewDataSource(
    viewModel: viewModel,
    memberDataSource: membersDataSource
  )
  private lazy var membersDataSource: UICollectionViewDataSource = MembersCollectionViewDataSource(viewModel: viewModel, delegate: self)

  private lazy var sideBarMinimumX: CGFloat = view.bounds.width * 0.25
  private lazy var sideBarMaximumX: CGFloat = view.bounds.width
  private lazy var sideBarLatestX: CGFloat = sideBarMaximumX // 제스쳐 start 시 갱신되는 가장 최신의 X 좌표
  private var sideBarCurrentState: SideBarState = .collapsed
  private lazy var sideBarView: SideBarView = {
    let frame = CGRect(
      x: view.bounds.width,
      y: topHeight,
      width: view.bounds.width - sideBarMinimumX + 10,
      height: view.bounds.height - topHeight
    )
    
    return SideBarView(
      frame: frame,
      viewModel: viewModel,
      dataSource: sideBarDataSource
    )
  }()
  
  private let animationTime: TimeInterval = 0.2
  private let maximumAlpha: CGFloat = 0.3
  private var topHeight: CGFloat = 0
  
  
  // MARK: - Initializer
  
  init(
    nibName: String,
    bundle: Bundle?,
    viewModel: SideBarViewModelProtocol,
    coordinator: BoardDetailCoordinator
  ) {
    self.viewModel = viewModel
    self.coordinator = coordinator

    super.init(nibName: nibName, bundle: bundle)
  }
  
  required init?(coder: NSCoder) {
    fatalError("This code should be initialized with code")
  }
  
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}


// MARK: - Extension Configure Method

private extension SideBarViewController {
  
  func configure() {
    sideBarView.delegate = self
    view.addSubview(sideBarView)
    
    configureView()
    configureSideBarView()
  }
  
  func configureView() {
    configureBackground(toAlpha: 0)

    view.isUserInteractionEnabled = false
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dimmerViewTapped))
    tapGestureRecognizer.delegate = self
    view.addGestureRecognizer(tapGestureRecognizer)
  }
  
  func configureSideBarView() {
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(sideBarDragged))
    sideBarView.addGestureRecognizer(panGestureRecognizer)
  }
  
  func configureBackground(toAlpha alpha: CGFloat) {
    self.view.backgroundColor = UIColor.black.withAlphaComponent(alpha)
  }
}


// MARK: - Extension Drag Method

private extension SideBarViewController {
  
  @objc func sideBarDragged(recognizer: UIPanGestureRecognizer) {
    
    let alpha = (1 - (sideBarView.frame.origin.x - sideBarMinimumX) / (sideBarMaximumX - sideBarMinimumX)) * maximumAlpha
    configureBackground(toAlpha: alpha)
    
    switch recognizer.state {
    case .began:
      sideBarLatestX = sideBarView.frame.origin.x
      
    case .changed:
      let translation = recognizer.translation(in: sideBarView)
      let expectedX = sideBarLatestX + translation.x
      
      if (sideBarMinimumX...sideBarMaximumX) ~= expectedX {
        sideBarView.frame.origin.x = expectedX
      }
      
    case .ended:
      let velocity = recognizer.velocity(in: sideBarView)
      if velocity.x > 1000 {
        animateSideBarView(to: .collapsed, withDuration: animationTime)
        return
      }
      
      // SideBarView X 좌표 기준 자동 확대 / 축소
      let sideBarMidX = (sideBarMaximumX + sideBarMinimumX) / 2
      
      if (sideBarMinimumX...sideBarMidX) ~= sideBarView.frame.origin.x {
        animateSideBarView(to: .expanded, withDuration: animationTime)
      } else {
        animateSideBarView(to: .collapsed, withDuration: animationTime)
      }
      
    default:
      break
    }
  }
  
  @objc func dimmerViewTapped() {
    animateSideBarView(to: .collapsed, withDuration: animationTime)
  }
  
  func animateSideBarView (to state: SideBarState, withDuration duration: TimeInterval, bounce: CGFloat = 0) {
    
    let frameAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
      switch state {
      case .expanded:
        self.sideBarView.frame.origin.x = self.sideBarMinimumX - 10
        
        self.view.isUserInteractionEnabled = true
        self.configureBackground(toAlpha: self.maximumAlpha)
        
        self.sideBarCurrentState = .expanded
        
      case .collapsed:
        self.sideBarView.frame.origin.x = self.sideBarMaximumX
        
        self.view.isUserInteractionEnabled = false
        self.configureBackground(toAlpha: 0)
        
        self.sideBarCurrentState = .collapsed
      }
    }
    
    frameAnimator.addCompletion { _ in
      switch state {
      case .expanded:
        UIViewPropertyAnimator(duration: 0.1, curve: .easeIn) {
          self.sideBarView.frame.origin.x = self.sideBarMinimumX
        }.startAnimation()
        
      default:
        break
      }
    }
    
    sideBarLatestX = sideBarView.frame.origin.x
    frameAnimator.startAnimation()
  }
}


// MARK: - Extension UIGestureRecognizer Delegate

extension SideBarViewController: UIGestureRecognizerDelegate {
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return touch.view?.isDescendant(of: sideBarView) == true ? false : true
  }
}


// MARK: - Extension SideBarViewProtocol

extension SideBarViewController: SideBarViewControllerProtocol {
  
  func pushInvitation() {
    coordinator?.pushInvitation(delegate: self, members: viewModel.members())
  }
  
  func start() {
    configure()
  }
  
  func configureTopHeight(to topHeight: CGFloat) {
    self.topHeight = topHeight
  }
  
  func view() -> UIView {
    return view
  }
  
  func expandSideBar() {
    viewModel.updateCollectionView()
    animateSideBarView(to: .expanded, withDuration: animationTime)
  }
}


// MARK: - Extension InvitationViewController Delegate

extension SideBarViewController: InvitationViewControllerDelegate {
  
  func reloadMemberCollectionView() {
    viewModel.updateCollectionView()
  }
}


extension SideBarViewController: SideBarViewDelegate {
  
  func boardDeleteButtonTapped() {
    DispatchQueue.main.async { [weak self] in
      self?.coordinator?.pop()
    }
  }
  
  func successBoardDelete(confirmAction: @escaping () -> Void) {
    let alert = UIAlertController(
      alertType: .boardDelete,
      alertStyle: .actionSheet,
      confirmAction: {
        confirmAction()
      })
    
    present(alert, animated: true)
  }
}
