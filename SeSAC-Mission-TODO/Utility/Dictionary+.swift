//
//  Dictionary+.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/17/24.
//

extension Dictionary {
  func mapKeys<K: Hashable>(_ transform: (Key) -> K) -> [K: Value] {
    var newDict: [K: Value] = [:]
    
    self.forEach {
      let transformedKey = transform($0.key)
      newDict.updateValue($0.value, forKey: transformedKey)
      
    }
    return newDict
  }
}
