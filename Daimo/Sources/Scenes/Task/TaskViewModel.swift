//
//  TaskViewModel.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import RxSwift
import RxCocoa
import Resolver

final class TaskViewModel: BaseViewModel {
  
  @Injected var dateService: DateServiceType
  
  struct Event {
    let onAppear = PublishRelay<Void>()
  }
  
  struct State {
    let periodTypes = PublishRelay<[PeriodType]>()
    let createTask = PublishRelay<Void>()
  }
  
  let event = Event()
  let state = State()
}

extension TaskViewModel {
  override func reduce() {
    super.reduce()
    event.onAppear.take(1)
      .compactMap { [weak self] in self?.dateService.fetchPeriodTypes() }
      .bind(to: state.periodTypes)
      .disposed(by: disposeBag)
  }
}
