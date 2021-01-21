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
    static let cellSpace = CGFloat(16)
    static let titleHeightWithPadding = titleTopPadding + titleHeight + titleBottomPadding
    static let cellHeight = TaskViewController.Metric.periodViewHeight - titleHeightWithPadding
  }
  
  private let viewModel = PeriodViewModel()
  
  private let titleLabel = UILabel()
  private let collectionView: BaseCollectionView = {
    let layout = UICollectionViewFlowLayout()
    let cv = BaseCollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    layout.minimumLineSpacing = 16
    layout.scrollDirection = .horizontal
    layout.itemSize.width = Metric.cellWidth
    layout.itemSize.height = Metric.cellHeight
    return cv
  }()
  
  private var periodType: PeriodType?
  private var currentIndex: CGFloat = 0
  private var isOneStepPaging = true
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
      $0.isPagingEnabled = false
      $0.decelerationRate = .fast
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
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    let sideInset = (collectionView.frame.size.width - Metric.cellWidth) / 2
    return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
  }
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
  func scrollViewWillEndDragging(
    _ scrollView: UIScrollView,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {
    // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
    let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
    
    // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
    // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
    var offset = targetContentOffset.pointee
    let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
    var roundedIndex = round(index)
    
    // scrollView, targetContentOffset의 좌표 값으로 스크롤 방향을 알 수 있다.
    // index를 반올림하여 사용하면 item의 절반 사이즈만큼 스크롤을 해야 페이징이 된다.
    // 스크로로 방향을 체크하여 올림,내림을 사용하면 좀 더 자연스러운 페이징 효과를 낼 수 있다.
    if scrollView.contentOffset.x > targetContentOffset.pointee.x {
      roundedIndex = floor(index)
    } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
      roundedIndex = ceil(index)
    } else {
      roundedIndex = round(index)
    }
    
    if isOneStepPaging {
      if currentIndex > roundedIndex {
        currentIndex -= 1
        roundedIndex = currentIndex
      } else if currentIndex < roundedIndex {
        currentIndex += 1
        roundedIndex = currentIndex
      }
    }
    
    // 위 코드를 통해 페이징 될 좌표값을 targetContentOffset에 대입하면 된다.
    offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
    targetContentOffset.pointee = offset
  }
}
