//
//  BaseTableView.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/22.
//

import UIKit
import RxSwift
import RxCocoa

class BaseTableView: UITableView {
  
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    setupUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupUI()
  }
  
  @objc dynamic func setupUI() {
    rowHeight = UITableView.automaticDimension
    estimatedRowHeight = 54
    separatorStyle = .none
  }
}
