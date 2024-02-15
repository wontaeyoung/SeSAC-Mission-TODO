//
//  TodoItem.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/14/24.
//

import UIKit
import KazUtility

struct TodoItem: Entity {
  
  let id: UUID
  var title: String
  var memo: String
  var dueDate: Date
  var tags: [String]
  var isFlag: Bool
  var priority: Int
  var image: UIImage?
  var isDone: Bool
  
  var isToday: Bool {
    return DateFormatManager.shared.toString(with: dueDate, format: .yyyyMMdd)
    == DateFormatManager.shared.toString(with: Date.now, format: .yyyyMMdd)
  }
  
  var todoPriority: TodoPriority {
    return TodoPriority(rawValue: priority) ?? .none
  }
  
  static var empty: TodoItem {
    return TodoItem(
      id: UUID(),
      title: "",
      memo: "",
      dueDate: .now,
      tags: [],
      isFlag: false,
      priority: 3,
      image: nil,
      isDone: false
    )
  }
}

enum TodoPriority: Int, CaseIterable {
  
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


enum TodoState: String, CaseIterable {
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
    return UIButton.Configuration.filled().configured {
      $0.image = UIImage(systemName: symbol)
      $0.baseForegroundColor = tintColor
      $0.baseBackgroundColor = backColor
      $0.cornerStyle = .capsule
      $0.buttonSize = .mini
    }
  }
}
