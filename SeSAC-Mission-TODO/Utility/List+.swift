//
//  List+.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/18/24.
//

import RealmSwift

extension List {
  static func from(array: [Element]) -> List<Element> {
    let list = List<Element>()
    list.append(objectsIn: array)
    
    return list
  }
}
