//
//  BaseCellNode.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/22.
//

import Foundation
import AsyncDisplayKit
import RxSwift

class BaseCellNode: ASCellNode {
  
  var disposeBag = DisposeBag()
  
  override init() {
    super.init()
    automaticallyManagesSubnodes = true
    selectionStyle = .none
  }
}


