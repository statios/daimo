//
//  DateType.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import Foundation
import UIKit

enum PeriodType: CaseIterable {
  case daily
  case weekly
  case monthly
  case yearly
}

extension PeriodType {
  var title: String {
    switch self {
    case .daily: return "Daily"
    case .weekly: return "Weekly"
    case .monthly: return "Monthly"
    case .yearly: return "Yearly"
    }
  }
  
  var color: UIColor {
    switch self {
    case .daily: return Color.peach
    case .weekly: return Color.paleTeal
    case .monthly: return Color.lightGreyBlue
    case .yearly: return Color.lavenderPink
    }
  }
}
