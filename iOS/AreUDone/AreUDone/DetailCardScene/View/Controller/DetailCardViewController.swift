//
//  DetailCardViewController.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/25.
//

import UIKit

final class DetailCardViewController: UIViewController {
  
  // MARK:- Property
  
  private let viewModel: DetailCardViewModelProtocol
  private var observer: NSKeyValueObservation?
  
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.backgroundColor = .red
    
    return scrollView
  }()
  
  private lazy var stackView: DetailCardStackView = {
    let stackView = DetailCardStackView()
    
    return stackView
  }()
  
  private lazy var detailCardTableView: UITableView = {
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    return tableView
  }()
  
  
  // MARK:- Initializer
  
  init?(coder: NSCoder, viewModel: DetailCardViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("This controller must be initialized with code")
  }
  
  
  // MARK:- Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    bindUI()
    
    viewModel.fetchDetailCard()
  }
}


// MARK:- Extension

private extension DetailCardViewController {
  
  // TODO:- make datasource
}


// MARK:- Extension Configure Method

private extension DetailCardViewController {
  
  func configure() {
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationBar.prefersLargeTitles = true
    
    view.addSubview(scrollView)
    
    configureScrollView()
    configureStackView()
  }
  
  func configureScrollView() {
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
  
  func configureStackView() {
    scrollView.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
    ])
  }
  
  func configureDetailCardTableView() {
    stackView.addArrangedSubview(detailCardTableView)
    detailCardTableView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      detailCardTableView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
    ])
  }
}


// MARK:- Extension BindUI

private extension DetailCardViewController {
  
  private func bindUI() {
    observationNavigationBar()
    bindingDetailCardContentView()
    bindingDetailCardDueDateView()
    bindingDetailCardCommentsView()
  }
  
  private func observationNavigationBar() {
    observer = navigationController?.navigationBar.observe(
      \.bounds,
      options: [.new, .initial],
      changeHandler: { (navigationBar, changes) in
        if let height = changes.newValue?.height {
          if height > 44.0 {
            //Large Title
          } else {
            //Small Title
          }
        }
      })
  }
  
  private func bindingDetailCardContentView() {
    viewModel.bindingDetailCardContentView { [weak self] content in
      self?.stackView.updateContentView(with: content)
    }
  }
  
  private func bindingDetailCardDueDateView() {
    viewModel.bindingDetailCardDueDateView { [weak self] dueDate in
      self?.stackView.updateDueDateView(with: dueDate)
    }
  }
  
  private func bindingDetailCardCommentsView() {
    viewModel.bindingDetailCardCommentsView { comments in
      
    }
  }
}
