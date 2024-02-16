//
//  HomeViewModel.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/14/24.
//

import Foundation
import KazUtility

final class HomeViewModel: ViewModel {
  
  // MARK: - Property
  weak var coordinator: HomeCoordinator?
  
  // MARK: - Initializer
  init(coordinator: HomeCoordinator? = nil) {
    self.coordinator = coordinator
    
    NotificationManager.shared.add(self, key: TodoNotificationNameKey.todoItemAdded) { notification in
      guard
        let info = notification.userInfo,
        let data = info[TodoNotificationInfoKey.todoItem.name] as? TodoItem
      else {
        LogManager.shared.log(with: NotificationError.infoNotFound(key: TodoNotificationInfoKey.todoItem), to: .local)
        return
      }
      
      var current = self.todoItems.current
      current.append(data)
      self.todoItems.set(current)
    }
  }
  
  // MARK: - Bindable
  lazy var todoItems: Bindable<[TodoItem]> = .init(value: [])
  
  // MARK: - Method
  func filter(by state: TodoItem.State) -> [TodoItem] {
    let current = todoItems.current
    
    switch state {
      case .today:
        return current.filter { $0.isToday }
      case .plan:
        return current.filter { !$0.isDone }
      case .all:
        return current
      case .flag:
        return current.filter { $0.isFlag }
      case .done:
        return current.filter { $0.isDone }
    }
  }
  
  func filteredCount(by state: TodoItem.State) -> Int {
    return filter(by: state).count
  }
  
  @MainActor
  func showAddTodoView() {
    coordinator?.showAddTodoView()
  }
}

enum TodoNotificationNameKey: String, NotificationNameKey {
  
  case todoItemAdded = "TodoItemAdded"
}

enum TodoNotificationInfoKey: String, NotificationInfoKey {
  
  case todoItem
}

struct TodoNotificationInfo: NotificationInfo {
  
  var key: TodoNotificationInfoKey
  var value: Any
}
