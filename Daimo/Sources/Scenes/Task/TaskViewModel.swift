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
  }
  
  struct State {
    let addTask = PublishRelay<Task>()
    let tasks = PublishRelay<[Task]>()
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
    
    event.tappedAddButton
      .do(onNext: { [weak self] in
        self?.coreDataService.insert(task: $0)
      }).bind(to: state.addTask)
      .disposed(by: disposeBag)
  }
}
