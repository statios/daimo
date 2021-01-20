//
//  HeaderView.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import UIKit

final class PeriodView: BaseView {
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
    return cv
  }()
}

extension PeriodView {
  override func setupUI() {
    super.setupUI()
    titleLabel.do {
      $0.add(to: self)
      $0.snp.makeConstraints { (make) in
        make.leading.equalToSuperview().offset(16)
        make.top.equalToSuperview().offset(16)
      }
      $0.font = Font.champagneBold.withSize(16)
      $0.textColor = Color.greyishBrown
    }
    
    collectionView.do {
      $0.add(to: self)
      $0.snp.makeConstraints { (make) in
        make.trailing.leading.equalToSuperview()
        make.top.equalTo(titleLabel.snp.bottom).offset(8)
        make.bottom.equalToSuperview().offset(-8)
      }
      $0.isPagingEnabled = true
      $0.register(cellType: PeriodCell.self)
    }
  }
}

extension PeriodView {
  func configure(_ item: PeriodType) {
    titleLabel.text = item.title
  }
}
