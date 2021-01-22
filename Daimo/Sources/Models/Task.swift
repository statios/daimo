//
//  Task+CoreDataClass.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/22.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {

}

extension Task {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
    return NSFetchRequest<Task>(entityName: "Task")
  }

  @NSManaged public var content: String?
  @NSManaged public var periodType: Int16
  @NSManaged public var isDone: Bool
  @NSManaged public var date: Date?

}

extension Task: Identifiable {

}
