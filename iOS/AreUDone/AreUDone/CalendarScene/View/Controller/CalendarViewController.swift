//
//  CalendarViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/21.
//

import UIKit

final class CalendarViewController: UIViewController {
  
  // MARK: - Property
  
  private let viewModel: CalendarViewModelProtocol
  weak var calendarCoordinator: CalendarCoordinator?
  
  @IBOutlet weak var dateLabel: DateLabel!
  @IBOutlet weak var currentDateLabel: UILabel!
  @IBOutlet weak var cardTableView: UITableView!
  
  
  // MARK: - Initializer
  
  init?(coder: NSCoder, viewModel: CalendarViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("This controller must be initialized with code")
  }
  
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }
}


// MARK: - Extension

extension CalendarViewController {
  
  private func configure() {
    configureCardTableView()
  }
  
  private func configureCardTableView() {
    cardTableView.register(CardTableViewCell.self)
  }
}
