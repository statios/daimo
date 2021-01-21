//
//  PeriodCell.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/21.
//

import Foundation
import UIKit

final class PeriodCell: BaseCollectionViewCell {
  let dateLabel = UILabel() // TODO access control
}

extension PeriodCell {
  override func setupUI() {
    super.setupUI()
    dateLabel.do {
      $0.add(to: contentView)
      $0.snp.makeConstraints { (make) in
        make.centerY.equalToSuperview()
        make.leading.equalToSuperview().offset(16)
      }
      $0.font = Font.champagneBold.withSize(16)
      $0.textColor = Color.white
    }
  }
}

extension PeriodCell {
  func configure(
    _ item: PeriodType?
  ) {
    contentView.backgroundColor = item?.color
  }
}
