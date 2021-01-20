//
//  ObservableType+.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import RxSwift
import RxCocoa

extension ObservableType {
  func asObservableVoid() -> Observable<Void> {
    return map { _ in }
  }
  
  func unwrap<Result>() -> Observable<Result> where Element == Result? {
    return self.compactMap { $0 }
  }
  
  func withPrevious(startWith first: Element) -> Observable<(Element, Element)> {
    return scan((first, first)) { ($0.1, $1) }
  }
  
  func catchErrorJustComplete() -> Observable<Element> {
    return catchError { _ in
      return Observable.empty()
    }
  }
  
  func asDriverOnErrorJustComplete() -> Driver<Element> {
    return asDriver { error in
      return Driver.empty()
    }
  }
}

extension ObservableConvertibleType where Element == Void {
  func asDriver() -> Driver<Element> {
    return self.asDriver(onErrorJustReturn: Void())
  }
}

