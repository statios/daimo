//
//  SplashAnimationView.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/25.
//

import UIKit
import RxSwift
import RxCocoa

class SplashAnimationView: BaseView {
  
  let titleLabel = UILabel().then {
    $0.text = "D A I M O"
    $0.font = UIFont.systemFont(ofSize: 23)
    $0.textColor = Color.darkGray
    $0.alpha = 0.25
  }
  
  let paleTealView = UIView().then {
    $0.backgroundColor = Color.paleTeal
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    $0.layer.cornerRadius = 5
  }
  
  let lavenderPinkView = UIView().then {
    $0.backgroundColor = Color.lavenderPink
    $0.layer.maskedCorners = [.layerMaxXMaxYCorner]
    $0.layer.cornerRadius = 5
  }
  
  let lightGreyBlueView = UIView().then {
    $0.backgroundColor = Color.lightGreyBlue
  }
  
  let peachView = UIView().then {
    $0.backgroundColor = Color.peach
    $0.layer.maskedCorners = [.layerMinXMaxYCorner]
    $0.layer.cornerRadius = 5
  }
  
  
}

extension SplashAnimationView {
  override func setupUI() {
    super.setupUI()
    titleLabel.do {
      $0.add(to: self)
      $0.snp.makeConstraints { (make) in
        make.center.equalToSuperview()
      }
    }
    
    peachView.do {
      $0.add(to: self)
      $0.snp.makeConstraints { (make) in
        make.leading.equalTo(titleLabel)
        make.width.height.equalTo(20)
        make.top.equalTo(self.snp.bottom)
      }
    }
    
    lavenderPinkView.do {
      $0.add(to: self)
      $0.snp.makeConstraints { (make) in
        make.leading.equalTo(self.snp.trailing)
        make.bottom.equalTo(titleLabel.snp.top).offset(-4)
        make.width.height.equalTo(20)
      }
    }
    
    lightGreyBlueView.do {
      $0.add(to: self)
      $0.snp.makeConstraints { (make) in
        make.bottom.equalTo(self.snp.top)
        make.leading.equalTo(peachView.snp.trailing).offset(2)
        make.height.equalTo(lavenderPinkView)
        make.trailing.equalTo(titleLabel).offset(-22)
      }
    }
    
    paleTealView.do {
      $0.add(to: self)
      $0.snp.makeConstraints { (make) in
        make.trailing.equalTo(self.snp.leading)
        make.bottom.equalTo(titleLabel.snp.top).offset(-22)
        make.height.equalTo(40)
        make.width.equalTo(titleLabel)
      }
    }
  }
}


extension SplashAnimationView {
  func animateSplash() -> Observable<Void> {
    return Observable.create { (emitter) -> Disposable in
      UIView.animate(withDuration: 1.0) {
        self.peachView.snp.remakeConstraints { (make) in
          make.leading.equalTo(self.titleLabel)
          make.width.height.equalTo(20)
          make.bottom.equalTo(self.titleLabel.snp.top).offset(-4)
        }
        self.layoutIfNeeded()
      }
      
      UIView.animate(withDuration: 1.0) {
        self.lavenderPinkView.snp.remakeConstraints { (make) in
          make.trailing.equalTo(self.titleLabel)
          make.bottom.equalTo(self.titleLabel.snp.top).offset(-4)
          make.width.height.equalTo(20)
        }
        self.layoutIfNeeded()
      }
      
      UIView.animate(withDuration: 1.0) {
        self.lightGreyBlueView.snp.remakeConstraints { (make) in
          make.bottom.equalTo(self.titleLabel.snp.top).offset(-4)
          make.leading.equalTo(self.peachView.snp.trailing).offset(2)
          make.height.equalTo(self.lavenderPinkView)
          make.trailing.equalTo(self.titleLabel).offset(-22)
        }
        self.layoutIfNeeded()
      }
      
      UIView.animate(withDuration: 1.0) {
        self.paleTealView.snp.remakeConstraints { (make) in
          make.leading.equalTo(self.titleLabel)
          make.bottom.equalTo(self.titleLabel.snp.top).offset(-26)
          make.height.equalTo(40)
          make.width.equalTo(self.titleLabel)
        }
        self.layoutIfNeeded()
      }
      
      UIView.animate(withDuration: 1.0, delay: 1.0, options: []) {
        self.titleLabel.alpha = 0.85
      } completion: { (_) in
        emitter.onNext(())
      }

      return Disposables.create()
    }
  }
}
