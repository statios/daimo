//
//  TaskCell.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/22.
//

import Foundation
import UIKit

final class TaskCell: BaseTableViewCell {
  private let doneView = UIView()
  private let textField = UITextField()
}

extension TaskCell {
  override func setupUI() {
    super.setupUI()
    contentView.do {
      $0.backgroundColor = .blue
    }
    
    doneView.do {
      $0.add(to: contentView)
      $0.snp.makeConstraints { (make) in
        make.leading.equalToSuperview().offset(4)
        make.top.equalToSuperview().offset(4)
        make.bottom.equalToSuperview().offset(-4)
        make.width.equalTo(44)
      }
      $0.backgroundColor = .red
    }
    
    textField.do {
      $0.add(to: contentView)
      $0.snp.makeConstraints { (make) in
        make.leading.equalTo(doneView.snp.trailing).offset(4)
        make.trailing.equalToSuperview().offset(-8)
        make.top.bottom.equalTo(doneView)
      }
      $0.backgroundColor = .brown
    }
  }
}

extension TaskCell {
  func configure(_ task: Task) {
    textField.isUserInteractionEnabled = false //TODO remove
    if task.content == "" {
      DispatchQueue.main.async { [weak self] in
        self?.textField.becomeFirstResponder()
      }
    } else {
      textField.isUserInteractionEnabled = false
    }
  }
}
