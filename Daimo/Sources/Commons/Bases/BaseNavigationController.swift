//
//  BaseNavigationController.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import RxSwift
import UIKit

class BaseNavigationController: UINavigationController {

  var disposeBag = DisposeBag()
  
  override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)
//    Log.verbose(String(describing: Self.self))
    configure()
    setupUI()
    setupBinding()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
//    Log.verbose(String(describing: Self.self))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @objc dynamic func configure() {
    modalPresentationStyle = .overFullScreen
  }
  
  @objc dynamic func setupUI() {
    
  }
  
  @objc dynamic func setupBinding() {

  }
}

