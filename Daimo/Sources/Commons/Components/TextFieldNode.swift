//
//  TextFieldNode .swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/23.
//

import Foundation
import AsyncDisplayKit
import UIKit

class TextFieldNode: BaseNode {
  
  var textField: UITextField? {
    return view as? UITextField
  }
  
  override init() {
    super.init()
    setViewBlock { UITextField() }
  }
  
}

