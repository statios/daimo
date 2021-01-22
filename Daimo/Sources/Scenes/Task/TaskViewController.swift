//
//  TaskViewController.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import UIKit
import SnapKit
import AsyncDisplayKit

final class TaskViewController: BaseViewController {
  struct Metric {
    static let periodViewHeight: CGFloat = .init(156)
  }
  
  private let viewModel = TaskViewModel()
  private let tableView = BaseTableView()
  
  private var periodTypes = [PeriodType]()
  private var tasks = [Task]()
}

extension TaskViewController {
  override func configure() {
    super.configure()
    self.do {
      $0.modalPresentationStyle = .overFullScreen
    }
  }
}

extension TaskViewController {
  override func setupUI() {
    super.setupUI()
    view.do {
      $0.backgroundColor = .white
    }
    
    tableView.do {
      $0.add(to: view)
      $0.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
      $0.backgroundColor = .white
      $0.sectionHeaderHeight = Metric.periodViewHeight
      $0.delegate = self
      $0.dataSource = self
      $0.register(cellType: TaskCell.self)
      $0.rowHeight = 4 + 44 + 4
      $0.estimatedRowHeight = 4 + 44 + 4
    }
  }
}

extension TaskViewController {
  override func setupBinding() {
    super.setupBinding()
    // Event
    rx.viewWillAppear.asObservableVoid()
      .bind(to: viewModel.event.onAppear)
      .disposed(by: disposeBag)
    
    // State
    viewModel.state.periodTypes
      .asDriverOnErrorJustComplete()
      .drive(onNext: { [weak self] in
        self?.periodTypes = $0
        self?.tableView.reloadData()
      }).disposed(by: disposeBag)
  }
}

extension TaskViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tasks.filter { $0.periodType == periodTypes[section].rawValue }.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: TaskCell.className,
      for: indexPath
    ) as? TaskCell else { fatalError() }
    let task = tasks.filter { $0.periodType == periodTypes[indexPath.section].rawValue }[indexPath.row]
    cell.configure(task)
    return cell
  }
}

extension TaskViewController: UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return periodTypes.count
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = PeriodView()
    headerView.configure(periodTypes[section])
    headerView.delegate = self
    return headerView
  }
}

extension TaskViewController: PeriodViewDelegate {
  func didSelectPeriod(_ type: PeriodType, date: Date) {
    let task = Task()
    task.periodType = type.rawValue
    tasks.insert(task, at: 0)
    let indexPath = IndexPath(item: 0, section: type.rawValue)
    //    tableView.isUserInteractionEnabled = false
    
    tableView.beginUpdates()
    tableView.insertRows(at: [indexPath], with: .none)
    tableView.endUpdates()
//    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    
  }
}
