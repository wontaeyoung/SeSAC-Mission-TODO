//
//  HomeViewModel.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/14/24.
//

import Foundation
import KazUtility
import RealmSwift

final class HomeViewModel: RealmCollectionViewmodel {
  
  typealias ObjectType = TodoBox
  
  // MARK: - Property
  weak var coordinator: HomeCoordinator?
  private let todoBoxRepository: any TodoBoxRepository
  private let todoItemRepository: any TodoItemRepository
  
  // MARK: - Model
  let collection: Results<ObjectType>
  var bindAction: ((Results<ObjectType>) -> Void)?
  var notificationToken: NotificationToken?
  
  // MARK: - Initializer
  init(
    coordinator: HomeCoordinator? = nil,
    todoBoxRepository: any TodoBoxRepository,
    todoItemRepository: any TodoItemRepository
  ) {
    self.coordinator = coordinator
    self.todoBoxRepository = todoBoxRepository
    self.todoItemRepository = todoItemRepository
    self.collection = todoBoxRepository.fetch()
  }
  
  deinit {
    notificationToken?.invalidate()
  }
}

extension HomeViewModel {
  
  func filter(by state: TodoItem.State) -> Results<TodoItem> {
    let today = Calendar.current.startOfDay(for: .now)
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
    
    switch state {
      case .today:
        return todoItemRepository.fetch()
          .where(column: .dueDate, comparison: .greaterEqual, value: today as NSDate)
          .where(column: .dueDate, comparison: .less, value: tomorrow as NSDate)
        
      case .plan:
        return todoItemRepository.fetch()
          .where { !$0.isDone }
          .where(column: .dueDate, comparison: .greaterEqual, value: tomorrow as NSDate)
      
      case .all:
        return todoItemRepository.fetch()
      
      case .flag:
        return todoItemRepository.fetch()
          .where { $0.isFlag }
      
      case .done:
        return todoItemRepository.fetch()
          .where { $0.isDone }
    }
  }
  
  func filteredCount(by state: TodoItem.State) -> Int {
    return filter(by: state).count
  }
}

extension HomeViewModel {
  
  @MainActor
  func showAddTodoView() {
    coordinator?.combineAddTodoFlow()
  }
  
  @MainActor
  func showTodoListView(state: TodoItem.State) {
    coordinator?.showTodoListView(with: filter(by: state), state: state)
  }
}
