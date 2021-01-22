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
  
  var calendarComponents: Set<Calendar.Component> {
    switch self {
    case .daily: return [.year, .month, .day]
    case .weekly: return [.year, .month, .day, .weekday]
    case .monthly: return [.year, .month]
    case .yearly: return [.year]
    }
  }
  
  var byAdding: Calendar.Component {
    switch self {
    case .daily, .weekly: return .day
    case .monthly: return .month
    case .yearly: return .year
    }
  }
  
  var dateFormat: String {
    switch self {
    case .daily: return "EEEE, MMMd yyyy"
    case .weekly: return "EE, MMMd"
    case .monthly: return "MMMM, yyyy"
    case .yearly: return "yyyy"
    }
  }
}
