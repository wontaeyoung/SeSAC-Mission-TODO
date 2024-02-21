//
//  String+.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/19/24.
//

extension String {
  var emptyToDash: String {
    return self.isEmpty ? "-" : self
  }
  
  var emptyToShop: String {
    return self.isEmpty ? "#" : self
  }
}
