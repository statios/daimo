//
//  SplashViewController.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import UIKit

final class SplashViewController: BaseViewController {
  
  let viewModel = SplashViewModel()
  
}

extension SplashViewController {
  override func setupUI() {
    super.setupUI()
  }
}

extension SplashViewController {
  override func setupBinding() {
    super.setupBinding()
    // Event
    rx.viewWillAppear.asObservableVoid()
      .bind(to: viewModel.event.onAppear)
      .disposed(by: disposeBag)
    
    // State
    viewModel.state.present.compactMap { $0 }
      .asDriverOnErrorJustComplete()
      .drive { [weak self] in self?.present($0, animated: true) }
      .disposed(by: disposeBag)
  }
}
