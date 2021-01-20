//
//  SplashViewModel.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import RxSwift
import RxCocoa
import UIKit

final class SplashViewModel: BaseViewModel {
  
  struct Event {
    let onAppear = PublishRelay<Void>()
  }
  
  struct State {
    let present = BehaviorRelay<UIViewController?>(value: nil)
  }
  
  let event = Event()
  let state = State()
}

extension SplashViewModel {
  override func reduce() {
    super.reduce()
    event.onAppear
      .delay(.milliseconds(2000), scheduler: MainScheduler.instance)
      .map { BaseNavigationController(rootViewController: TaskViewController()) }
      .bind(to: state.present)
      .disposed(by: disposeBag)
  }
}

