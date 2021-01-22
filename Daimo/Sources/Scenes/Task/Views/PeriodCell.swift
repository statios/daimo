//
//  PeriodCell.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/21.
//

import Foundation
import UIKit

final class PeriodCell: BaseCollectionViewCell {
  private let dateLabel = UILabel()
}

extension PeriodCell {
  override func setupUI() {
    super.setupUI()
    
    contentView.do {
      $0.layer.cornerRadius = 12
    }
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
  
  override func prepareForReuse() {
    super.prepareForReuse()
    dateLabel.text = nil
  }
}

extension PeriodCell {
  func configure(
    _ item: PeriodType?,
    date: Date
  ) {
    guard let period = item else { return }
    contentView.backgroundColor = period.color
    dateLabel.text = date.dateFormat(period.dateFormat)
    if period == .weekly {
      let extraDate = Calendar.current.date(byAdding: .day, value: 7, to: date)
      let dateFormat = period.dateFormat + ", yyyy"
      let extraDateString = extraDate!.dateFormat(dateFormat)
      dateLabel.text! += " - " + extraDateString //TODO remove force unwrap
    }
  }
}
