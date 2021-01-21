//
//  BaseCollectionView.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/21.
//

import UIKit

class BaseCollectionView: UICollectionView {
  var flowLayout: UICollectionViewFlowLayout? {
    return collectionViewLayout as? UICollectionViewFlowLayout
  }
}
