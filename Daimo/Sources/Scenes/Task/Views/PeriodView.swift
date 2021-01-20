//
//  HeaderView.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import UIKit

final class PeriodView: BaseView {
  fileprivate struct Metric {
    static let titleTopPadding = CGFloat(16)
    static let titleHeight = CGFloat(20)
    static let titleBottomPadding = CGFloat(8)
    static let cellWidth = Device.width - 24 - 24
    static let titleHeightWithPadding = titleTopPadding + titleHeight + titleBottomPadding
    static let cellHeight = TaskViewController.Metric.periodViewHeight - titleHeightWithPadding
  }
  
  private let viewModel = PeriodViewModel()
  
  private let titleLabel = UILabel()
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let cv = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 16
    layout.scrollDirection = .horizontal
    layout.itemSize.width = Metric.cellWidth
    layout.itemSize.height = Metric.cellHeight
    return cv
  }()
  
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
      $0.isPagingEnabled = true
      $0.register(cellType: PeriodCell.self)
    }
  }
}

extension PeriodView {
  override func setupBinding() {
    super.setupBinding()
    viewModel.state.displayTitle
      .asDriverOnErrorJustComplete()
      .drive(titleLabel.rx.text)
      .disposed(by: disposeBag)
  }
}

extension PeriodView {
  func configure(_ item: PeriodType) {
    viewModel.event.onConfigure.accept(item)
    periodType = item
  }
}

extension PeriodView: UICollectionViewDelegateFlowLayout {
//  func collectionView(
//    _ collectionView: UICollectionView,
//    layout collectionViewLayout: UICollectionViewLayout,
//    sizeForItemAt indexPath: IndexPath)
//  -> CGSize {
//    return CGSize(width: Device.width - 32, height: 100)
//  }
}

extension PeriodView: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return 10
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PeriodCell.className,
            for: indexPath
    ) as? PeriodCell else { fatalError() }
    cell.configure(periodType)
    return cell
  }
}

extension PeriodView: UICollectionViewDelegate {
  
}
