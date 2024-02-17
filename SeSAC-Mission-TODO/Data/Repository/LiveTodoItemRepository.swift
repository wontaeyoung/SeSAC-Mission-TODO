//
//  LiveTodoItemRepository.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/17/24.
//

import KazUtility
import RealmSwift

final class LiveTodoItemRepository: TodoItemRepository {
  
  private let realm: Realm = try! Realm()
  private var objects: Results<TodoItem> {
    return realm.objects(TodoItem.self)
  }
  
  func create(with item: TodoItem) throws {
    try realm.write {
      realm.add(item)
    }
  }
  
  func fetch() -> Results<TodoItem> {
    return objects
  }
  
  func fetchSorted(by column: TodoItem.Column, ascending: Bool = true) -> Results<TodoItem> {
    return objects
      .sorted(byKeyPath: column.name, ascending: ascending)
  }
  
  func update(to item: TodoItem, with value: [TodoItem.Column : Any]) throws {
    let columns = value.mapKeys { $0.name }
    let mergedWithID = [TodoItem.Column.id.name: item.id].merging(columns) { $1 }
    
    try realm.write {
      realm.create(TodoItem.self, value: mergedWithID, update: .modified)
    }
  }
  
  func updateColumnAll(with objects: Results<TodoItem>, in column: TodoItem.Column, value: Any) throws {
    try realm.write {
      objects.setValue(value, forKey: column.name)
    }
  }
  
  func delete(with item: TodoItem) throws {
    try realm.write {
      realm.delete(item)
    }
  }
  
  func deleteCollection(with objects: Results<TodoItem>) throws {
    try realm.write {
      realm.delete(objects)
    }
  }
}
