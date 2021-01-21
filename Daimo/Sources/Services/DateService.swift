//
//  DateService.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import Foundation

protocol DateServiceType {
  func fetchPeriodTypes() -> [PeriodType]
  func fetchToday(_ type: PeriodType) -> Date
  func fetchTodays(_ type: PeriodType) -> [Date]
  func prefetchDate(_ type: PeriodType, direction: Int, date: Date) -> Date
}

class StubDateService: DateServiceType {
  func fetchPeriodTypes() -> [PeriodType] {
    return PeriodType.allCases
  }
  
  func fetchToday(_ type: PeriodType) -> Date {
    let components = Calendar.current.dateComponents(type.calendarComponents, from: Date())
    if type == .weekly {
      let weekday = components.weekday ?? 1
      let date = Calendar.current.date(from: components) ?? Date()
      let addedDate = Calendar.current.date(byAdding: .day, value: -(weekday - 1), to: date) ?? Date()
      return addedDate
    }
    return Calendar.current.date(from: components) ?? Date()
  }
  
  func fetchTodays(_ type: PeriodType) -> [Date] {
    return [0, 1, 2, 3, -3, -2, -1].compactMap { Calendar.current.date(byAdding: type.byAdding, value: $0, to: fetchToday(type)) }
  }
  
  func prefetchDate(_ type: PeriodType, direction: Int, date: Date) -> Date {
    Calendar.current.date(byAdding: type.byAdding, value: direction * 3, to: date) ?? Date()
  }
}

//class DateService: DateServiceType {
//  
//}
