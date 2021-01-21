//
//  HeaderView.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import UIKit
import RxSwift
import InfiniteLayout

final class PeriodView: BaseView {
  fileprivate struct Metric {
    static let titleTopPadding = CGFloat(16)
    static let titleHeight = CGFloat(20)
    static let titleBottomPadding = CGFloat(8)
    static let cellWidth = Device.width - 24 - 24
    static let cellSpace = CGFloat(16)
    static let titleHeightWithPadding = titleTopPadding + titleHeight + titleBottomPadding
    static let cellHeight = TaskViewController.Metric.periodViewHeight - titleHeightWithPadding
  }
  
  private let viewModel = PeriodViewModel()
  
  private let titleLabel = UILabel()
  private let collectionView: InfiniteCollectionView = {
    let layout = InfiniteLayout()
    let cv = InfiniteCollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    layout.minimumLineSpacing = 16
    layout.scrollDirection = .horizontal
    layout.itemSize.width = Metric.cellWidth
    layout.itemSize.height = Metric.cellHeight
    return cv
  }()
  
  private var periodDates = [Date]()
  private var periodType: PeriodType?
}

extension PeriodView {
  override func setupUI() {
    super.setupUI()
    self.backgroundColor = .brown
    
    titleLabel.do {
      $0.add(to: self)
      $0.snp.makeConstraints { (make) in
        make.leading.equalToSuperview().offset(24)
        make.top.equalToSuperview().offset(16)
        make.height.equalTo(Metric.titleHeight)
      }
      $0.font = Font.champagneBold.withSize(16)
      $0.textColor = Color.greyishBrown
      $0.backgroundColor = .red
    }
    
    collectionView.do {
      $0.add(to: self)
      $0.snp.makeConstraints { (make) in
        make.trailing.leading.equalToSuperview()
        make.top.equalTo(titleLabel.snp.bottom)
          .offset(Metric.titleBottomPadding)
        make.height.equalTo(Metric.cellHeight)
      }
      $0.delegate = self
      $0.dataSource = self
      $0.register(cellType: PeriodCell.self)
      $0.isItemPagingEnabled = true
      $0.infiniteDelegate = self
    }
  }
}

extension PeriodView {
  override func setupBinding() {
    super.setupBinding()
    // Event
    
    // State
    viewModel.state.displayTitle
      .asDriverOnErrorJustComplete()
      .drive(titleLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.state.displayItems
      .asDriverOnErrorJustComplete()
      .drive(onNext: { [weak self] in
        self?.periodDates = $0
        self?.collectionView.reloadData()
      }).disposed(by: disposeBag)
    
    viewModel.state.updatePrefetchedDate
      .debug()
      .bind { [weak self] _ in
        
//        self?.periodDates[$0.index] = $0.date
      }.disposed(by: disposeBag)
  }
}

extension PeriodView {
  func configure(_ item: PeriodType) {
    viewModel.event.onConfigure.accept(item)
    periodType = item
  }
}

extension PeriodView: UICollectionViewDelegateFlowLayout {
    func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      insetForSectionAt section: Int
    ) -> UIEdgeInsets {
      return UIEdgeInsets(top: 0, left: Metric.cellSpace, bottom: 0, right: 0)
    }
}

extension PeriodView: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return periodDates.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: PeriodCell.className,
      for: indexPath
    ) as? PeriodCell else { fatalError() }
    let infiniteIndexPath = self.collectionView.indexPath(from: indexPath)
    cell.configure(periodType)
    cell.dateLabel.text = periodDates[infiniteIndexPath.item].debugDescription
    return cell
  }
}

extension PeriodView: InfiniteCollectionViewDelegate {
  func infiniteCollectionView(
    _ infiniteCollectionView: InfiniteCollectionView,
    didChangeCenteredIndexPath from: IndexPath?,
    to: IndexPath?
  ) {
    guard let from = from,
          let to = to else { return }
    let before = infiniteCollectionView.indexPath(from: from).item
    let after = infiniteCollectionView.indexPath(from: to).item
    let direction = after > before ? 1 : -1
    let request = DatePrefetch.Request(
      direction: direction,
      index: after,
      date: periodDates[after]
    )
    viewModel.event.requestDatePrefetch.accept(request)
  }
}
