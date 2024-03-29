//
//  TodoItem.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/14/24.
//

import UIKit
import KazUtility
import RealmSwift

final class TodoItem: Object, RealmModel {
  
  enum Column: String {
    case id
    case title
    case memo
    case dueDate
    case tags
    case isFalg
    case priority
    case imageData
    case isDone
    
    var name: String {
      return self.rawValue
    }
  }
  
  @Persisted(primaryKey: true) var id: ObjectId
  @Persisted var title: String
  @Persisted var memo: String
  @Persisted var dueDate: Date
  @Persisted var tags: List<TodoTag>
  @Persisted var isFlag: Bool
  @Persisted var priority: Int
  @Persisted var isDone: Bool
  @Persisted(originProperty: TodoBox.Column.items.name) var box: LinkingObjects<TodoBox>
  
  var todoPriority: Priority {
    return Priority(rawValue: priority) ?? .none
  }
  
  var tagString: String {
    return tags
      .map { "#" + $0.name }
      .joined(separator: " ")
  }
  
  convenience init(
    title: String = "",
    memo: String = "",
    dueDate: Date = .now,
    tags: List<TodoTag> = .init(),
    isFlag: Bool = false,
    priority: Int = 0,
    isDone: Bool = false
  ) {
    self.init()
    
    self.title = title
    self.memo = memo
    self.dueDate = dueDate
    self.tags = tags
    self.isFlag = isFlag
    self.priority = priority
    self.isDone = isDone
  }
  
  static var empty: TodoItem {
    return TodoItem()
  }
  
  var copied: TodoItem {
    return TodoItem().configured {
      $0.id = id
      $0.title = title
      $0.memo = memo
      $0.dueDate = dueDate
      $0.tags = tags
      $0.isFlag = isFlag
      $0.priority = priority
      $0.isDone = isDone
    }
  }
}

extension TodoItem {
  enum Priority: Int, CaseIterable {
    
    case none = 0
    case low
    case middle
    case high
    
    var title: String {
      switch self {
        case .high:
          return "높음"
        
        case .middle:
          return "중간"
          
        case .low:
          return "낮음"
          
        case .none:
          return "없음"
      }
    }
    
    var index: Int {
      return self.rawValue
    }
  }


  enum State: String, CaseIterable {
    case today = "오늘"
    case plan = "예정"
    case all = "전체"
    case flag = "깃발 표시"
    case done = "완료됨"
    
    var title: String {
      return self.rawValue
    }
    
    var symbol: String {
      switch self {
        case .today, .plan:
          return "calendar"
          
        case .all:
          return "tray.fill"
          
        case .flag:
          return "flag.fill"
          
        case .done:
          return "checkmark"
      }
    }
    
    var tintColor: UIColor {
      return .label
    }
    
    var backColor: UIColor {
      switch self {
        case .today:
          return .systemBlue
        
        case .plan:
          return .systemRed
          
        case .all:
          return .gray
        
        case .flag:
          return .systemYellow
          
        case .done:
          return .lightGray
      }
    }
    
    var config: UIButton.Configuration {
      return .filled().configured {
        $0.image = UIImage(systemName: symbol)
        $0.baseForegroundColor = tintColor
        $0.baseBackgroundColor = backColor
        $0.cornerStyle = .capsule
        $0.buttonSize = .medium
        $0.preferredSymbolConfigurationForImage = .init(pointSize: 10)
      }
    }
  }
}
