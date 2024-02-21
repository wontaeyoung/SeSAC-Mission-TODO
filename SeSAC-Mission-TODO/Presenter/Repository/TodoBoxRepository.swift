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
  func update(to item: TodoBox, with value: [TodoBox.Column: Any]) throws
  func updateColumnAll(with objects: Results<TodoBox>, in column: TodoBox.Column, value: Any) throws
  func delete(with item: TodoBox) throws
  func deleteCollection(with objeects: Results<TodoBox>) throws
}
