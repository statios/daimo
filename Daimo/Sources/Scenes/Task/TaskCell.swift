//
//  TaskCell.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/22.
//

import Foundation
import UIKit
import AsyncDisplayKit
import Resolver

final class TaskCell: BaseCellNode {
  
  @Injected var viewModel: TaskViewModel
  
  let containerNode = BaseNode().then {
    $0.style.preferredSize.height = 40
    $0.cornerRadius = 12
    $0.backgroundColor = Color.veryLightPink
  }
  
  let doneImageNode = ASImageNode().then {
    $0.style.preferredSize = CGSize(width: 24, height: 24)
    $0.tintColor = Color.greyishBrown
  }
  
  let taskTextNode = ASTextNode().then {
    $0.style.flexGrow = 1
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
      alignItems: .center,
      children: [doneImageNode, taskTextNode]
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
    var attributes = [
      NSAttributedString.Key.font: Font.yoonGothic230.withSize(13),
      NSAttributedString.Key.foregroundColor: Color.darkGray,
    ]
    let attstring = NSAttributedString(
      string: task?.content ?? "",
      attributes: attributes
    )
    taskTextNode.attributedText = attstring
    doneImageNode.image = task?.isDone == true ? Image.checkBox : Image.unCheckBox
  }
}
