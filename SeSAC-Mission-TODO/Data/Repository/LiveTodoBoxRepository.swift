//
//  LiveTodoBoxRepository.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/20/24.
//

import KazUtility
import RealmSwift

final class LiveTodoBoxRepository: TodoBoxRepository {
  
  private let realm: Realm = try! Realm()
  private var objects: Results<TodoBox> {
    print(realm.configuration.fileURL!)
    return realm.objects(TodoBox.self)
  }
  
  func create(with item: TodoBox) throws {
    try realm.write {
      realm.add(item)
    }
  }
  
  func fetch() -> Results<TodoBox> {
    return objects
  }
  
  func fetchSorted(by column: TodoBox.Column, ascending: Bool = true) -> Results<TodoBox> {
    return objects
      .sorted(byKeyPath: column.name, ascending: ascending)
  }
  
  func update(to item: TodoBox, with value: [TodoBox.Column : Any]) throws {
    let columns = value.mapKeys { $0.name }
    let mergedWithID = [TodoBox.Column.id.name: item.id].merging(columns) { $1 }
    
    try realm.write {
      realm.create(TodoBox.self, value: mergedWithID, update: .modified)
    }
  }
  
  func updateColumnAll(with objects: Results<TodoBox>, in column: TodoBox.Column, value: Any) throws {
    try realm.write {
      objects.setValue(value, forKey: column.name)
    }
  }
  
  func delete(with item: TodoBox) throws {
    try realm.write {
      realm.delete(item)
    }
  }
  
  func deleteCollection(with objects: Results<TodoBox>) throws {
    try realm.write {
      realm.delete(objects)
    }
  }
}

