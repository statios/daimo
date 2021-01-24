//
//  TaskViewModel.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import RxSwift
import RxCocoa
import Resolver
import UIKit

final class TaskViewModel: BaseViewModel {
  
  @Injected var dateService: DateServiceType
  @Injected var coreDataService: CoreDataServiceType
  
  struct Event {
    let onAppear = PublishRelay<Void>()
    let tappedAddButton = PublishRelay<Task>()
    let didSelectTask = PublishRelay<Task>()
    let didDeleteTask = PublishRelay<Task>()
  }
  
  struct State {
    let addTask = PublishRelay<Task>()
    let tasks = PublishRelay<[Task]>()
    let dates = PublishRelay<[Date]>()
  }
  
  let event = Event()
  let state = State()
}

extension TaskViewModel {
  override func reduce() {
    super.reduce()
    event.onAppear.take(1)
      .compactMap { [weak self] in self?.coreDataService.fetch(request: Task.fetchRequest() )}
      .bind(to: state.tasks)
      .disposed(by: disposeBag)
    
    event.onAppear.take(1)
      .map { PeriodType.allCases }
      .compactMap { [weak self] in $0.compactMap { type in self?.dateService.fetchDate(type, date: Date()) } }
      .bind(to: state.dates)
      .disposed(by: disposeBag)
    
    event.tappedAddButton
      .do(onNext: { [weak self] in
        self?.coreDataService.insert(object: $0)
      }).bind(to: state.addTask)
      .disposed(by: disposeBag)
    
    event.didSelectTask
      .bind { [weak self] in
        self?.coreDataService.insert(object: $0)
      }.disposed(by: disposeBag)
    
    event.didDeleteTask
      .bind { [weak self] in
        self?.coreDataService.delete(object: $0)
      }.disposed(by: disposeBag)
  }
}
