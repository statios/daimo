//
//  PeriodCell.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/21.
//

import Foundation
import UIKit

final class PeriodCell: BaseCollectionViewCell {
  
}

extension PeriodCell {
  override func setupUI() {
    super.setupUI()
  }
}

extension PeriodCell {
  func configure(_ item: PeriodType?) {
    self.backgroundColor = item?.color
  }
}
