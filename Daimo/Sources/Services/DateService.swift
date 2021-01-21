//
//  DateService.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import Foundation

protocol DateServiceType {
  func fetchPeriodTypes() -> [PeriodType]
//  func fetchDates(_ from: PeriodType) -> [Date]
}

class StubDateService: DateServiceType {
  func fetchPeriodTypes() -> [PeriodType] {
    return PeriodType.allCases
  }
}

//class DateService: DateServiceType {
//  
//}
