//
//  UITableView+.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import UIKit

extension UITableView {
  func register(cellType: UITableViewCell.Type) {
    self.register(cellType, forCellReuseIdentifier: cellType.className)
  }
}
