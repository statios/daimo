//
//  Date_.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/22.
//

import Foundation

extension Date {
  private static let dateFormatter = DateFormatter()
  
  func dateFormat(_ template: String) -> String {
    Date.dateFormatter.setLocalizedDateFormatFromTemplate(template)
    return Date.dateFormatter.string(from: self)
  }
}
