//
//  TaskCell.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/22.
//

import Foundation
import UIKit
import AsyncDisplayKit

final class TaskCell: BaseCellNode {
  
  let containerNode = BaseNode().then {
    $0.style.preferredSize.height = 40
    $0.cornerRadius = 12
    $0.backgroundColor = Color.veryLightPink
  }
  
  let doneNode = BaseNode().then {
    $0.style.preferredSize.width = 24
    $0.backgroundColor = .red
  }
  
  let textFieldNode = TextFieldNode().then {
    $0.style.flexGrow = 1
    $0.backgroundColor = .brown
  }
}

extension TaskCell {
  override func didLoad() {
    super.didLoad()
    backgroundColor = .white
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    
    let horizontalStackLayout = ASStackLayoutSpec(
      direction: .horizontal,
      spacing: 8,
      justifyContent: .start,
      alignItems: .stretch,
      children: [doneNode, textFieldNode]
    )
    
    let insetHorizontalStackLayout = ASInsetLayoutSpec(
      insets: .init(top: 8, left: 8, bottom: 8, right: 8),
      child: horizontalStackLayout
    )
    
    let overlayLayout = ASOverlayLayoutSpec(
      child: containerNode,
      overlay: insetHorizontalStackLayout
    )
    
    return ASInsetLayoutSpec(
      insets: .init(top: 4, left: 8, bottom: 4, right: 8),
      child: overlayLayout
    )
  }
}

extension TaskCell {
  func configure(_ task: Task?) {
    
  }
}
