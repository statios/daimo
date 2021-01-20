//
//  AppDelegate+Inject.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import Resolver

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
    register { StubDateService() }
      .implements(DateServiceType.self)
  }
}
