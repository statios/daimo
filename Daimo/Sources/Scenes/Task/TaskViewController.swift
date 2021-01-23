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
  
  private let tableNode = ASTableNode()
  private let taskInputView = TaskInputView()
  
  private var periodTypes = [PeriodType]()
  private var tasks = [Task]()
  
  override var inputAccessoryView: UIView? {
    return taskInputView
  }
  
  override var canBecomeFirstResponder: Bool {
    return true
  }
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
    return tasks.filter { $0.periodType == periodTypes[section].rawValue }.count
  }
  
  func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    return { [weak self] in
      let cell = TaskCell()
      let task = self?.tasks.filter { $0.periodType == self?.periodTypes[indexPath.section].rawValue }[indexPath.row]
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
  func didSelectPeriod(_ type: PeriodType, date: Date) {
    taskInputView.textField.becomeFirstResponder()
    taskInputView.addButton.backgroundColor = type.color
  }
}

// MARK: - Helpers
extension TaskViewController {
}
