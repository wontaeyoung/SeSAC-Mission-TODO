//
//  RealmModel.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/17/24.
//

import Foundation
import RealmSwift

protocol RealmModel: Object {
  
  associatedtype Column: RawRepresentable where Column.RawValue == String
}

extension Results where Element: RealmModel {
  
  enum Operator {
    enum Logical: String {
      case and = "&&"
      case or = "||"
    }
    
    enum Comparison: String {
      case less = "<"
      case lessEqual = "<="
      case equal = "=="
      case greaterEqual = ">="
      case greater = ">"
    }
  }
  
  func `where`(
    comparison: Operator.Comparison = .equal,
    column: Element.Column,
    value: any CVarArg
  ) -> Results<Element> {
    
    let predicateFormat: String = "\(column.rawValue) \(comparison.rawValue) %@"
    let predicate = NSPredicate(format: predicateFormat, value)
    
    return self.filter(predicate)
  }
}
