//
//  CoreDataService.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/22.
//

import Foundation
import CoreData

protocol CoreDataServiceType {
  func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T]
  @discardableResult func delete(object: NSManagedObject) -> Bool
  @discardableResult func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool
//  @discardableResult
//  func insertTask(
//    content: String,
//    isDone: Bool,
//    date: Date,
//    periodType: Int
//  ) -> Bool
}

class CoreDataService: CoreDataServiceType {
  private let persistentContainer = NSPersistentContainer(name: "Daimo").then {
    $0.loadPersistentStores { (storeDescription, error) in
      guard let error = error as NSError? else { return }
      fatalError("Unresolved error \(error), \(error.userInfo)")
    }
  }
  
  private var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
    do {
      let fetchResult = try context.fetch(request)
      return fetchResult
    } catch {
      fatalError(error.localizedDescription)
    }
  }
  
//  @discardableResult
//  func insertTask(
//    content: String,
//    isDone: Bool,
//    date: Date,
//    periodType: Int
//  ) -> Bool {
//    
//    guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else {
//      return false
//    }
//    
//    let object = NSManagedObject(entity: entity, insertInto: context)
//    object.setValue(content, forKey: "content")
//    object.setValue(isDone, forKey: "isDone")
//    object.setValue(date, forKey: "date")
//    object.setValue(periodType, forKey: "periodType")
//    
//    do {
//      try context.save()
//      return true
//    } catch {
//      Log.error(error.localizedDescription)
//      return false
//    }
//  }
  
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
