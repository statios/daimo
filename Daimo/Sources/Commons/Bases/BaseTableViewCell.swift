//
//  BaseTableViewCell.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/22.
//

import Foundation
import UIKit

class BaseTableViewCell: UITableViewCell {
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc dynamic func setupUI() {
    
  }
}

