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
import CoreData

final class PeriodViewModel: BaseViewModel {
  
  @Injected var dateService: DateServiceType
  @Injected var coreDataService: CoreDataServiceType
  
  struct Event {
    let onConfigure = PublishRelay<(PeriodType, Date)>()
    let requestDatePrefetch = PublishRelay<DatePrefetch.Request>()
    let didSelectDate = PublishRelay<Date>()
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
    
    Task(content: "", periodType: 0, isDone: true, date: Date())
    
    
    event.onConfigure
      .map { $0.0.title }
      .bind(to: state.displayTitle)
      .disposed(by: disposeBag)
    
    event.onConfigure
      .compactMap { [weak self] in self?.dateService.fetchDates($0.0, date: $0.1) }
      .bind(to: state.displayItems)
      .disposed(by: disposeBag)
    
    event.requestDatePrefetch
      .withLatestFrom(event.onConfigure) { [weak self] in
        let prefetchedDate = self?.dateService.prefetchDate($1.0, direction: $0.direction, date: $0.date)
        let plus = ($0.index + 3) % 7
        let minu = ($0.index + 4) % 7
        let response = DatePrefetch.Response(date: prefetchedDate ?? Date(), index: $0.direction > 0 ? plus : minu)
        return response
      }.bind(to: state.updatePrefetchedDate)
      .disposed(by: disposeBag)
  }
}

