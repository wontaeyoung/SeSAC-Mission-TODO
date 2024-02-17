//
//  RealmModel.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/17/24.
//

protocol RealmModel {
  
  associatedtype Column: RawRepresentable where Column.RawValue == String
}
