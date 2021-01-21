//
//  PrefetchDateRequest.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/21.
//

import Foundation

struct DatePrefetch {
  struct Request {
    let direction: Int
    let index: Int
    let date: Date
  }
  struct Response {
    let date: Date
    let index: Int
  }
}
