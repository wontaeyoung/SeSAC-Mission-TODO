//
//  TodoBoxRepository.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/20/24.
//

import RealmSwift

protocol TodoBoxRepository {
  
  // MARK: - Method
  func create(with item: TodoBox) throws
  func append(with item: TodoItem, to box: TodoBox) throws
  func fetch() -> Results<TodoBox>
  func fetchSorted(by column: TodoBox.Column, ascending: Bool) -> Results<TodoBox>
  func update(with box: TodoBox) throws
  func update(with box: TodoBox, updating action: (TodoBox) -> Void) throws
  func update(to item: TodoBox, with value: [TodoBox.Column: Any]) throws
  func updateListItem(to box: TodoBox, at item: TodoItem, updating action: (TodoItem) -> Void) throws
  func updateColumnAll(with objects: Results<TodoBox>, in column: TodoBox.Column, value: Any) throws
  func delete(with item: TodoBox) throws
  func deleteListItem(to box: TodoBox, at item: TodoItem) throws
  func disconnectListItem(to box: TodoBox, at item: TodoItem) throws
  func deleteCollection(with objeects: Results<TodoBox>) throws
}
