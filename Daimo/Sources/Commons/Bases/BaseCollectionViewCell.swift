//
//  BaseCollectionViewCell.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/21.
//

import Foundation
import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc dynamic func setupUI() {
    
  }
}
