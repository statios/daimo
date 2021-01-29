//
//  SplashViewController.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import UIKit
import Resolver
import RxSwift

final class SplashViewController: BaseViewController {
  
  @Injected var viewModel: SplashViewModel
  
  let animationView = SplashAnimationView()
  
}

extension SplashViewController {
  override func setupUI() {
    super.setupUI()
    animationView.do {
      $0.add(to: view)
      $0.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
      }
    }
  }
}

extension SplashViewController {
  override func setupBinding() {
    super.setupBinding()
    // Event
    rx.viewDidAppear.asObservableVoid()
      .flatMap { [weak self] _ -> Observable<Void> in
        guard let `self` = self else { fatalError() }
        return self.animationView.animateSplash()
      }.bind(to: viewModel.event.endAnimation)
      .disposed(by: disposeBag)
    
    // State
    viewModel.state.present.compactMap { $0 }
      .asDriverOnErrorJustComplete()
      .drive { [weak self] in self?.present($0, animated: true) }
      .disposed(by: disposeBag)
  }
}
