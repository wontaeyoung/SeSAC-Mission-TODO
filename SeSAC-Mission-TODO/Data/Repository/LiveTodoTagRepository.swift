//
//  LiveTodoTagRepository.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/18/24.
//

import KazUtility
import RealmSwift

final class LiveTodoTagRepository: TodoTagRepository {
  
  private let realm: Realm = try! Realm()
  private var objects: Results<TodoTag> {
    return realm.objects(TodoTag.self)
  }
  
  func create(with tag: TodoTag) throws {
    try realm.write {
      realm.add(tag, update: .all)
    }
  }
  
  func fetch() -> Results<TodoTag> {
    return objects
  }
  
  func fetchSorted(by column: TodoTag.Column, ascending: Bool = true) -> Results<TodoTag> {
    return objects
      .sorted(byKeyPath: column.name, ascending: ascending)
  }
  
  func delete(with tag: TodoTag) throws {
    try realm.write {
      realm.delete(tag)
    }
  }
}

