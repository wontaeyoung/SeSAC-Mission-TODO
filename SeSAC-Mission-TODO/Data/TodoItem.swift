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
  var state: TodoState
  var priority: TodoPriority
}

enum TodoPriority: String {
  case high = "높음"
  case middle = "중간"
  case low = "낮음"
  
  var title: String {
    return self.rawValue
  }
}


enum TodoState: String {
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
        return "calendar.circle.fill"
        
      case .all:
        return "tray.circle.fill"
        
      case .flag:
        return "flag.circle.fill"
        
      case .done:
        return "checkmark.circle.fill"
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
    }
  }
  
  var icon: UIButton {
    return UIButton(configuration: config)
  }
}
