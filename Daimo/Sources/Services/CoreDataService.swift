//
//  CoreDataService.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/22.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataServiceType {
  func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T]
  @discardableResult func delete(object: NSManagedObject) -> Bool
  @discardableResult func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool
  @discardableResult func insert<T: NSManagedObject>(object: T) -> Bool
}

class CoreDataService: CoreDataServiceType {
  
  var context: NSManagedObjectContext {
    guard let delegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
    return delegate.persistentContainer.viewContext
  }
  
  func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
    do {
      let fetchResult = try context.fetch(request)
      return fetchResult
    } catch {
      fatalError(error.localizedDescription)
    }
  }
  
  @discardableResult
  func insert<T: NSManagedObject>(object: T) -> Bool {
    do {
      try context.save()
      return true
    } catch {
      Log.error(error.localizedDescription)
      return false
    }
  }
  
  @discardableResult
  func delete(object: NSManagedObject) -> Bool {
    context.delete(object)
    do {
      try context.save()
      return true
    } catch {
      Log.error(error.localizedDescription)
      return false
    }
  }
  
  @discardableResult
  func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
    let request = T.fetchRequest()
    let delete = NSBatchDeleteRequest(fetchRequest: request)
    do {
      try context.execute(delete)
      return true
    } catch {
      Log.error(error.localizedDescription)
      return false
    }
  }
}
