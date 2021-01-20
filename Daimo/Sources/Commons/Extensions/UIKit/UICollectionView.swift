//
//  UICollectionView.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import UIKit

extension UICollectionView {
  func register(cellType: UICollectionViewCell.Type) {
    self.register(cellType, forCellWithReuseIdentifier: cellType.className)
  }
}

