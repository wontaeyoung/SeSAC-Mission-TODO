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
  
  /// 이 태그 레코드(인스턴스)를 포함하는 TodoItem과 역방향 관계 형성
  let todoItems = LinkingObjects(fromType: TodoItem.self, property: TodoItem.Column.tags.name)
  @Persisted(primaryKey: true) var name: String
  
  convenience init(name: String) {
    self.init()
    
    self.name = name
  }
}
