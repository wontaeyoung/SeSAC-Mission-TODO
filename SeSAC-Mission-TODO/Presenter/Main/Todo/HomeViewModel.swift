//
//  HomeViewModel.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/14/24.
//

import Foundation
import KazUtility
import RealmSwift

final class HomeViewModel: ViewModel {
  
  // MARK: - Property
  weak var coordinator: HomeCoordinator?
  private let repository: any TodoItemRepository
  
  // MARK: - Initializer
  init(coordinator: HomeCoordinator? = nil, repository: any TodoItemRepository) {
    self.coordinator = coordinator
    self.repository = repository
    self.todoItems = repository.fetch()
  }
  
  // MARK: - Bindable
  private var todoItems: Results<TodoItem>
  
  // MARK: - Method
  func filter(by state: TodoItem.State) -> [TodoItem] {
    switch state {
      case .today:
        return todoItems.filter { $0.isToday }
      case .plan:
        return todoItems.filter { !$0.isDone }
      case .all:
        return todoItems.map { $0 }
      case .flag:
        return todoItems.filter { $0.isFlag }
      case .done:
        return todoItems.filter { $0.isDone }
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
