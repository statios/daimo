//
//  AppDelegate+Inject.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import Resolver

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
    register { DateService() }
      .implements(DateServiceType.self)
      .scope(.shared)
    register { CoreDataService() }
      .implements(CoreDataServiceType.self)
      .scope(.shared)
    register { SplashViewModel() }
    register { TaskViewModel() }
      .scope(.shared)
    register { PeriodViewModel() }
      .scope(.unique)
  }
}
