//
//  BaseNode.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/22.
//

import AsyncDisplayKit

class BaseNode: ASDisplayNode {
  override init() {
    super.init()
    self.automaticallyManagesSubnodes = true
  }
}
