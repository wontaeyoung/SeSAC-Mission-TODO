//
//  TodoItemRepository.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/17/24.
//

import RealmSwift

protocol TodoItemRepository {
  
  // MARK: - Method
  func create(with item: TodoItem) throws
  func fetch() -> Results<TodoItem>
  func fetchSorted(by column: TodoItem.Column, ascending: Bool) -> Results<TodoItem>
  func update(to item: TodoItem, with value: [TodoItem.Column: Any]) throws
  func updateColumnAll(with objects: Results<TodoItem>, in column: TodoItem.Column, value: Any) throws
  func delete(with item: TodoItem) throws
  func deleteCollection(with objeects: Results<TodoItem>) throws
}
