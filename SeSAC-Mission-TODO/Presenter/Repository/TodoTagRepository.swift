//
//  TodoTagRepository.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/18/24.
//

import RealmSwift

protocol TodoTagRepository {
  
  // MARK: - Method
  func create(with tag: TodoTag) throws
  func fetch() -> Results<TodoTag>
  func fetchSorted(by column: TodoTag.Column, ascending: Bool) -> Results<TodoTag>
  func delete(with item: TodoTag) throws
}
