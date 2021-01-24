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
    static let periodViewHeight: CGFloat = (Device.height - 196) / 4
  }
  
  @Injected var viewModel: TaskViewModel
  
  // MARK: UI
  private let tableNode = ASTableNode(style: .grouped)
  private let taskInputView = TaskInputView()
  private let refreshControl = UIRefreshControl()
  
  // MARK: Data Store
  private var periodTypes = PeriodType.allCases
  private var currentDates = [Date]()
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
    
    self.do {
      $0.title = "DAIMO"
    }
    
    navigationController?.do {
      $0.navigationBar.isTranslucent = false
      $0.navigationBar.barTintColor = .white
      $0.navigationBar.shadowImage = UIImage()
      $0.navigationBar.setBackgroundImage(UIImage(), for: .default)
      $0.navigationBar.backgroundColor = .clear
      UINavigationBar.appearance().titleTextAttributes = [
        NSAttributedString.Key.foregroundColor: Color.greyishBrown,
        NSAttributedString.Key.font: Font.champagneBold.withSize(23)
      ]
//      $0.hidesBarsOnSwipe = true 
    }
    
    view.do {
      $0.backgroundColor = .white
    }
    
    tableNode.do {
      $0.backgroundColor = .white
      $0.delegate = self
      $0.dataSource = self
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
    
    refreshControl.do {
      $0.add(to: tableNode.view)
      $0.attributedTitle = NSAttributedString(
        string: "Today",
        attributes: [
          NSAttributedString.Key.foregroundColor: Color.greyishBrown
        ]
      )
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
    
    refreshControl.rx.controlEvent(.valueChanged)
      .bind(to: viewModel.event.onRefresh)
      .disposed(by: disposeBag)
    
    // State
    viewModel.state.addTask
      .asDriverOnErrorJustComplete()
      .drive(onNext: { [weak self] newTask in
        self?.tasks.append(newTask)
        let count = self?.tasks.filter { $0.periodType == newTask.periodType && $0.date == self?.currentDates[$0.periodType] }.count ?? 0
        let indexPath = IndexPath(row: count - 1, section: newTask.periodType)
        self?.tableNode.performBatchUpdates {
          self?.tableNode.insertRows(at: [indexPath], with: .left)
        } completion: { (_) in
          self?.tableNode.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
      }).disposed(by: disposeBag)
    
    Observable.zip(
      viewModel.state.tasks,
      viewModel.state.dates
    ).asDriverOnErrorJustComplete()
    .drive(onNext: { [weak self] in
      self?.tasks = $0.0
      self?.currentDates = $0.1
      self?.tableNode.reloadData()
      self?.refreshControl.endRefreshing()
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
    return tasks.filter {
      $0.periodType == section &&
      $0.date == currentDates[section]
    }.count
  }
  
  func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    return { [weak self] in
      guard let `self` = self else { fatalError() }
      let cell = TaskCell()
      let task = self.tasks.filter {
        $0.periodType == indexPath.section &&
        $0.date == self.currentDates[indexPath.section]
      }[indexPath.row]
      cell.configure(task)
      return cell
    }
  }
  
  func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
    let index = tasks.enumerated().filter {
      $0.element.periodType == indexPath.section &&
      $0.element.date == currentDates[indexPath.section]
    }[indexPath.row].offset
    
    tasks[index].isDone.toggle()
    
    tableNode.reloadRows(at: [indexPath], with: .fade)
    viewModel.event.didSelectTask.accept(tasks[index])
  }
  
  func tableView(
    _ tableView: UITableView,
    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
  ) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(
      style: .normal,
      title: "Delete"
    ) { [weak self] (action, view, success) in
      guard let `self` = self else { return }
      
      let index = self.tasks.enumerated().filter {
        $0.element.periodType == indexPath.section &&
        $0.element.date == self.currentDates[indexPath.section]
      }[indexPath.row].offset
      
      self.viewModel.event.didDeleteTask.accept(self.tasks[index])
      self.tasks.remove(at: index)
      self.tableNode.deleteRows(at: [indexPath], with: .left)
    }
    action.backgroundColor = Color.froly
    return UISwipeActionsConfiguration(actions: [action])
  }
}

extension TaskViewController: ASTableDelegate {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Metric.periodViewHeight
  }
  
  func numberOfSections(in tableNode: ASTableNode) -> Int {
    return periodTypes.count
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = PeriodView()
    headerView.configure(periodTypes[section], date: currentDates[section])
    headerView.delegate = self
    return headerView
  }
}

extension TaskViewController {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
  }
}

extension TaskViewController: PeriodViewDelegate {
  func didEndDisplayPeriod(_ type: PeriodType?, date: Date, direction: Int) {
    let section = type?.rawValue ?? 0
    
    let pre = tasks.filter {
      $0.periodType == section &&
      $0.date == currentDates[section]
    }.enumerated().map {
      IndexPath(row: $0.offset, section: section)
    }
    
    let cur = tasks.filter {
      $0.periodType == section &&
      $0.date == date
    }.enumerated().map {
      IndexPath(row: $0.offset, section: section)
    }
    currentDates[section] = date

    if pre.count > cur.count {
      let indexPaths = (cur.count...pre.count-1).map { IndexPath(row: $0, section: section) }
      tableNode.deleteRows(at: indexPaths, with: .bottom)
      tableNode.reloadRows(at: cur, with: .none)
    } else if pre.count == cur.count {
      tableNode.reloadRows(at: cur, with: .none)
    } else {
      let indexPaths = (pre.count...cur.count-1).map { IndexPath(row: $0, section: section) }
      tableNode.insertRows(at: indexPaths, with: .bottom)
      tableNode.reloadRows(at: pre, with: .none)
    }
    
  }
  
  func didSelectPeriod(_ type: PeriodType, date: Date) {
    taskInputView.textField.text = nil
    taskInputView.textField.becomeFirstResponder()
    taskInputView.addButton.backgroundColor = type.color.withAlphaComponent(0.5)
    addingPeriodType = type.rawValue
    addingDate = date
  }
}

// MARK: - Helpers
extension TaskViewController {
}
