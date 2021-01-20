//
//  BaseViewController.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import RxSwift
import UIKit

class BaseViewController: UIViewController {
  
  var disposeBag = DisposeBag()

  init() {
    super.init(nibName: nil, bundle: nil)
    Log.verbose(String(describing: Self.self))
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    Log.verbose(String(describing: Self.self))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBinding()
  }
  
  @objc dynamic func configure() {
    //Don't call view in here
  }
  
  @objc dynamic func setupUI() {
    view.do {
      $0.backgroundColor = .white
    }
  }
  
  @objc dynamic func setupBinding() {

  }

}


