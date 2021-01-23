//
//  Task+CoreDataClass.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/22.
//
//

import Foundation
import CoreData
import UIKit

@objc(Task)
public class Task: NSManagedObject {
  
  convenience init(content: String?,
                   periodType: Int,
                   isDone: Bool,
                   date: Date?) {
    guard let delegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
    let context = delegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)!
    self.init(entity: entity, insertInto: context)
    self.content = content
    self.periodType = periodType
    self.isDone = isDone
    self.date = date
  }
}

extension Task {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
    return NSFetchRequest<Task>(entityName: "Task")
  }

  @NSManaged public var content: String?
  @NSManaged public var periodType: Int
  @NSManaged public var isDone: Bool
  @NSManaged public var date: Date?

}

extension Task: Identifiable {

}
