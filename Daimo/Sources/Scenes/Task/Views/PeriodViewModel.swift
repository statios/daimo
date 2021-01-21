//
//  PeriodViewModel.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/21.
//

import Foundation
import RxSwift
import RxCocoa
import Resolver

final class PeriodViewModel: BaseViewModel {
  
  @Injected var dateService: DateServiceType
  
  struct Event {
    let onConfigure = PublishRelay<PeriodType>()
    let requestDatePrefetch = PublishRelay<DatePrefetch.Request>()
  }
  
  struct State {
    let displayTitle = PublishRelay<String>()
    let displayItems = PublishRelay<[Date]>()
    let updatePrefetchedDate = PublishRelay<DatePrefetch.Response>()
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
    
    event.onConfigure
      .compactMap { [weak self] in self?.dateService.fetchTodays($0) }
      .bind(to: state.displayItems)
      .disposed(by: disposeBag)
    
    event.requestDatePrefetch
      .withLatestFrom(event.onConfigure) { [weak self] in
        let prefetchedDate = self?.dateService.prefetchDate($1, direction: $0.direction, date: $0.date)
        let plus = ($0.index + 3) % 7
        let minu = ($0.index + 4) % 7
        let response = DatePrefetch.Response(date: prefetchedDate ?? Date(), index: $0.direction > 0 ? plus : minu)
        return response
      }.bind(to: state.updatePrefetchedDate)
      .disposed(by: disposeBag)
  }
}

