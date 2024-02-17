//
//  RealmModel.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/17/24.
//

import RealmSwift

protocol RealmModel: Object {
  
  associatedtype Column: RawRepresentable where Column.RawValue == String
}
