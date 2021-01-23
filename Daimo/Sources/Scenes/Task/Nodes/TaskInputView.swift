//
//  InputNode.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/24.
//

import Foundation
import UIKit

final class TaskInputView: UIView {
  
  let containerView = UIView()
  let textField = UITextField()
  let addButton = UIButton()
  
  init() {
    super.init(frame: .zero)
    
    isHidden = true
    backgroundColor = .white
    
    containerView.do {
      $0.add(to: self)
      $0.snp.makeConstraints { (make) in
        make.leading.equalToSuperview().offset(8)
        make.top.equalToSuperview().offset(8)
        make.bottom.equalToSuperview().offset(-8)
        make.trailing.equalToSuperview().offset(-8)
      }
      $0.layer.cornerRadius = 20
      $0.backgroundColor = Color.veryLightPink
    }
    
    addButton.do {
      $0.add(to: containerView)
      $0.snp.makeConstraints { (make) in
        make.trailing.equalToSuperview().offset(-4)
        make.size.equalTo(32)
        make.top.equalToSuperview().offset(4)
      }
      $0.layer.cornerRadius = 16
    }
    
    textField.do {
      $0.add(to: containerView)
      $0.snp.makeConstraints { (make) in
        make.leading.equalToSuperview().offset(16)
        make.trailing.equalTo(addButton.snp.leading).offset(-8)
        make.top.bottom.equalTo(addButton)
      }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


