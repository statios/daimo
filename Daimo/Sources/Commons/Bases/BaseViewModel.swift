//
//  BaseViewModel.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import Foundation
import RxSwift

class BaseViewModel {
  
  var disposeBag = DisposeBag()
  
  init() {
    Log.verbose(String(describing: Self.self))
    reduce()
  }
  
  deinit {
    Log.verbose(String(describing: Self.self))
  }
  
  @objc dynamic func reduce() {

  }
}
