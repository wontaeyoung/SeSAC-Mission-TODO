//
//  TodoBox.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/20/24.
//

import Foundation
import KazUtility
import RealmSwift

final class TodoBox: Object, RealmModel {
  
  enum Column: String {
    case id
    case name
    case createAt
    case icon
    case items
    
    var name: String {
      return self.rawValue
    }
  }
  
  @Persisted(primaryKey: true) var id: ObjectId
  @Persisted var name: String
  @Persisted var createAt: Date
  @Persisted var icon: BoxIcon?
  @Persisted var items: List<TodoItem>
  
  convenience init(name: String, icon: BoxIcon) {
    self.init()
    
    self.name = name
    self.createAt = .now
    self.icon = icon
    self.items = List<TodoItem>()
  }
  
  static var `default`: TodoBox {
    return .init(name: "기본 목록", icon: .default)
  }
}

final class BoxIcon: EmbeddedObject {
  
  @Persisted var color: String
  @Persisted var symbol: String
  
  var boxColor: BoxColor {
    return .init(rawValue: color) ?? .first
  }
  
  var boxSymbol: BoxSymbol {
    return .init(rawValue: symbol) ?? .first
  }
  
  static var `default`: BoxIcon {
    return .init(color: BoxColor.first.code, symbol: BoxSymbol.first.symbol)
  }
  
  convenience init(color: String, symbol: String) {
    self.init()
    
    self.color = color
    self.symbol = symbol
  }
  
  enum BoxColor: String, CaseIterable {
    
    case red = "#E94D3D"
    case orange = "#F19A37"
    case yellow = "#F6CD45"
    case green = "#5CC363"
    case skyblue = "#68A8EC"
    case blue = "#3478F6"
    
    var code: String {
      return self.rawValue
    }
    
    var index: Int {
      return Self.allCases.firstIndex(of: self) ?? 0
    }
    
    static var first: BoxColor {
      return .allCases.first ?? .red
    }
  }
  
  enum BoxSymbol: String, CaseIterable {
    
    case list = "list.bullet"
    case bookmark = "bookmark.fill"
    case doc = "doc.fill"
    case person = "figure.run"
    case controller = "gamecontroller.fill"
    case cart = "cart.fill"
    
    var symbol: String {
      return self.rawValue
    }
    
    var index: Int {
      return Self.allCases.firstIndex(of: self) ?? 0
    }
    
    static var first: BoxSymbol {
      return .allCases.first ?? .list
    }
  }
}
