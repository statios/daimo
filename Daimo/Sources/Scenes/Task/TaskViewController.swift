//
//  TaskViewController.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import UIKit
import SnapKit

final class TaskViewController: BaseViewController {
  
  private let viewModel = TaskViewModel()
  private let tableView = UITableView()
  
  private var periodTypes = [PeriodType]()
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
      $0.sectionHeaderHeight = 120
      $0.delegate = self
      $0.dataSource = self
      $0.register(cellType: UITableViewCell.self)
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
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
}

extension TaskViewController: UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return periodTypes.count
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = PeriodView()
    headerView.configure(periodTypes[section])
    headerView.collectionView.delegate = self
    headerView.collectionView.dataSource = self
    return headerView
  }
}

extension TaskViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath)
  -> CGSize {
    return CGSize(width: Device.width - 32, height: 100)
  }
}

extension TaskViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    UICollectionViewCell()
  }
}

extension TaskViewController: UICollectionViewDelegate {
  
}
