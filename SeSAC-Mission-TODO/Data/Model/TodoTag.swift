//
//  TodoTag.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/18/24.
//

import RealmSwift

final class TodoTag: Object, RealmModel {
  
  enum Column: String {
    case name
    
    var name: String {
      return self.rawValue
    }
  }
  
  @Persisted(primaryKey: true) var name: String
  @Persisted(originProperty: TodoItem.Column.tags.name) var todo: LinkingObjects<TodoItem>
  
  convenience init(name: String) {
    self.init()
    
    self.name = name
  }
}
