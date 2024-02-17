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
  @Persisted var tags: List<String>
  @Persisted var isFlag: Bool
  @Persisted var priority: Int
  @Persisted var imageData: Data?
  @Persisted var isDone: Bool
  
  var isToday: Bool {
    return DateFormatManager.shared.toString(with: dueDate, format: .yyyyMMdd)
    == DateFormatManager.shared.toString(with: Date.now, format: .yyyyMMdd)
  }
  
  var todoPriority: Priority {
    return Priority(rawValue: priority) ?? .none
  }
  
  convenience init(
    title: String = "",
    memo: String = "",
    dueDate: Date = .now,
    tags: List<String> = .init(),
    isFlag: Bool = false,
    priority: Int = 0,
    imageData: Data? = nil,
    isDone: Bool = false
  ) {
    self.init()
    
    self.title = title
    self.memo = memo
    self.dueDate = dueDate
    self.tags = tags
    self.isFlag = isFlag
    self.priority = priority
    self.imageData = imageData
    self.isDone = isDone
  }
  
  static var empty: TodoItem {
    return TodoItem()
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
