//
//  PeriodViewModel.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/21.
//

import RxSwift
import RxCocoa
import Resolver

final class PeriodViewModel: BaseViewModel {
  
  struct Event {
    let onConfigure = PublishRelay<PeriodType>()
  }
  
  struct State {
    let displayTitle = PublishRelay<String>()
  }
  
  let event = Event()
  let state = State()
}

extension PeriodViewModel {
  override func reduce() {
    super.reduce()
    event.onConfigure
      .map { $0.title }
      .bind(to: state.displayTitle)
      .disposed(by: disposeBag)
  }
}

