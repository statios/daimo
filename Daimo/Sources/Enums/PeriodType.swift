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
    case .daily: return 
    case .weekly: return 
    case .monthly: return 
    case .yearly: return 
    }
  }
}
