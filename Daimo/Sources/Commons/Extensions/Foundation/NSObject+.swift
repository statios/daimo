//
//  NSObject+.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import Foundation

extension NSObject {
  static var className: String {
    return String(describing: Self.self)
  }
}
