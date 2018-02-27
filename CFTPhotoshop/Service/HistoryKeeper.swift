//
//  HistoryKeeper.swift
//  CFTPhotoshop
//
//  Created by Aleksandr X on 27.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import UIKit
import CoreData

struct EditResult {
  var id: Int?
  let image: UIImage
  let filterName: String
}

protocol Keeper {
  associatedtype Object
  
  func save(object: inout Object) throws
  func getAllObjects() throws -> [Object]
}

class HistoryKeeper: Keeper {
  typealias Object = EditResult

  func save(object: inout EditResult) throws {
    var record: HistoryRecord?

    
    let context = CoreDataManager.shared.context
    if let id = object.id {
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataManager.EntityType.historyRecord.rawValue)
      request.predicate = NSPredicate(format: "id = %d", id)
      request.returnsObjectsAsFaults = false

      if let result = try context.fetch(request) as? [HistoryRecord] {
        record = result.first
      }
    } else {
      record = try newHistoryRecord()
      if record != nil {
        object.id = Int(record!.id)
      }
    }
    
    record?.imageData = UIImagePNGRepresentation(object.image)
    record?.filterName = object.filterName
    try context.save()
  }
  
  func getAllObjects() throws -> [EditResult] {
    let context = CoreDataManager.shared.context

    let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataManager.EntityType.historyRecord.rawValue)
    let result = try context.fetch(request) as? [HistoryRecord]
    return result?.flatMap({ editResult(from: $0) }) ?? []
  }
  
  private func newHistoryRecord() throws -> HistoryRecord? {
    let allObjects = try getAllObjects()
    let newId = (allObjects.max(by: { $0.id ?? 0 > $1.id ?? 0 })?.id ?? 0) + 1
    
    let context = CoreDataManager.shared.context
    if let entity = NSEntityDescription.entity(forEntityName: CoreDataManager.EntityType.historyRecord.rawValue, in: context) {
      let newRecord = HistoryRecord(entity: entity, insertInto: context)
      newRecord.id = Int64(newId)
      return newRecord
    }
    return nil
  }
  
  private func editResult(from hisoryRecord: HistoryRecord) -> EditResult? {
    guard
      let data = hisoryRecord.imageData,
      let image = UIImage(data: data),
      let filterName = hisoryRecord.filterName else {
      return nil
    }
    
    return EditResult(id: Int(hisoryRecord.id), image: image, filterName: filterName)
  }
}
