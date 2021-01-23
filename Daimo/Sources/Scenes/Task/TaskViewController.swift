//
//  TaskViewController.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import UIKit
import SnapKit
import AsyncDisplayKit
import Resolver
import RxSwift

final class TaskViewController: BaseASViewController {
  struct Metric {
    static let periodViewHeight: CGFloat = .init(156)
  }
  
  @Injected var viewModel: TaskViewModel
  
  // MARK: UI
  private let tableNode = ASTableNode()
  private let taskInputView = TaskInputView()
  
  // MARK: Data Store
  private var periodTypes = PeriodType.allCases
  lazy var currentDates = Array(repeating: Date(), count: periodTypes.count)
  private var tasks = [Task]()
  private var addingDate: Date?
  private var addingPeriodType: Int?
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
  override func layoutSpec(node: ASDisplayNode, size: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec(
      insets: .zero,
      child: tableNode
    )
  }
}

extension TaskViewController {
  override func setupUI() {
    super.setupUI()
    view.do {
      $0.backgroundColor = .white
    }
    
    tableNode.do {
      $0.backgroundColor = .white
      $0.delegate = self
      $0.dataSource = self
      $0.view.sectionHeaderHeight = Metric.periodViewHeight
      $0.view.separatorStyle = .none
      $0.view.keyboardDismissMode = .onDrag
    }
    
    taskInputView.do {
      $0.add(to: view)
      $0.snp.makeConstraints { (make) in
        make.leading.trailing.equalToSuperview()
        make.bottom.equalTo(view.keyboardLayoutGuideNoSafeArea.snp.top)
        make.height.equalTo(56)
      }
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
    
    taskInputView.addButton.rx.tap
      .do(onNext: { [weak self] in self?.view.endEditing(true) })
      .map { [weak self] in
        guard let `self` = self else { fatalError() }
        return Task(
          content: self.taskInputView.textField.text,
          periodType: self.addingPeriodType ?? 0,
          isDone: false,
          date: self.addingDate
        )
      }.bind(to: viewModel.event.tappedAddButton)
      .disposed(by: disposeBag)
    
    // State
    viewModel.state.addTask
      .asDriverOnErrorJustComplete()
      .drive(onNext: { [weak self] newTask in
        self?.tasks.append(newTask)
        let count = self?.tasks.filter { $0.periodType == newTask.periodType }.count ?? 0
        let indexPath = IndexPath(row: count - 1, section: newTask.periodType)
        self?.tableNode.performBatchUpdates {
          self?.tableNode.insertRows(at: [indexPath], with: .left)
        } completion: { (_) in
          self?.tableNode.scrollToRow(at: indexPath, at: .top, animated: true)
        }
      }).disposed(by: disposeBag)
    
    viewModel.state.tasks
      .asDriverOnErrorJustComplete()
      .drive(onNext: { [weak self] in
        self?.tasks = $0
        self?.tableNode.reloadData()
      }).disposed(by: disposeBag)
    
    RxKeyboard.instance.visibleHeight
      .drive(onNext: { [weak self] in
        self?.tableNode.contentInset.bottom = $0
      }).disposed(by: disposeBag)
    
    Observable.merge(
      taskInputView.textField.rx.controlEvent(.editingDidBegin).map { false },
      taskInputView.textField.rx.controlEvent(.editingDidEnd).map { true }
    ).bind(to: taskInputView.rx.isHidden)
    .disposed(by: disposeBag)
  }
}

extension TaskViewController: ASTableDataSource {
  
  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return tasks.filter { $0.periodType == periodTypes[section].rawValue && $0.date == currentDates[$0.periodType] }.count
  }
  
  func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    return { [weak self] in
      let cell = TaskCell()
      let task = self?.tasks.filter {
        $0.periodType == self?.periodTypes[indexPath.section].rawValue
          && $0.date == self?.currentDates[$0.periodType] }[indexPath.row]
      cell.configure(task)
      return cell
    }
  }
}

extension TaskViewController: ASTableDelegate {
  
  func numberOfSections(in tableNode: ASTableNode) -> Int {
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
  func didEndDisplayPeriod(_ type: PeriodType?, date: Date) {
    let section = type?.rawValue ?? 0
    self.currentDates[section] = date
    tableNode.reloadSections(.init(integer: section), with: .automatic)
  }
  
  func didSelectPeriod(_ type: PeriodType, date: Date) {
    taskInputView.textField.text = nil
    taskInputView.textField.becomeFirstResponder()
    taskInputView.addButton.backgroundColor = type.color
    addingPeriodType = type.rawValue
    addingDate = date
  }
}

// MARK: - Helpers
extension TaskViewController {
}
