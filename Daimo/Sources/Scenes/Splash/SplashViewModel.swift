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
    let endAnimation = PublishRelay<Void>()
  }
  
  struct State {
    let present = PublishRelay<UIViewController>()
  }
  
  let event = Event()
  let state = State()
}

extension SplashViewModel {
  override func reduce() {
    super.reduce()
    event.endAnimation
      .map { BaseNavigationController(rootViewController: TaskViewController()) }
      .bind(to: state.present)
      .disposed(by: disposeBag)
  }
}

