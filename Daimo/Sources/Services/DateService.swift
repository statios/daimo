//
//  DateService.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import Foundation

protocol DateServiceType {
  func fetchPeriodTypes() -> [PeriodType]
  func fetchDate(_ type: PeriodType, date: Date) -> Date
  func fetchDates(_ type: PeriodType, date: Date) -> [Date]
  func prefetchDate(_ type: PeriodType, direction: Int, date: Date) -> Date
}

class DateService: DateServiceType {
  func fetchPeriodTypes() -> [PeriodType] {
    return PeriodType.allCases
  }
  
  func fetchDate(_ type: PeriodType, date: Date) -> Date {
    let components = Calendar.current.dateComponents(type.calendarComponents, from: date)
    if type == .weekly {
      let weekday = components.weekday ?? 1
      let date = Calendar.current.date(from: components) ?? Date()
      let addedDate = Calendar.current.date(byAdding: .day, value: -(weekday - 1), to: date) ?? Date()
      return addedDate
    }
    
    return Calendar.current.date(from: components) ?? Date()
  }
  
  func fetchDates(_ type: PeriodType, date: Date) -> [Date] {
    return [0, 1, 2, 3, -3, -2, -1].compactMap {
      if type == .weekly {
        return Calendar.current.date(byAdding: type.byAdding, value: $0 * 7, to: fetchDate(type, date: date))
      }
      return Calendar.current.date(byAdding: type.byAdding, value: $0, to: fetchDate(type, date: date))
    }
  }
  
  func prefetchDate(_ type: PeriodType, direction: Int, date: Date) -> Date {
    if type == .weekly {
      return Calendar.current.date(byAdding: type.byAdding, value: (direction * 3) * 7, to: date) ?? Date()
    }
    return Calendar.current.date(byAdding: type.byAdding, value: direction * 3, to: date) ?? Date()
  }
}
