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
  
  typealias ObjectType = TodoItem
  
  // MARK: - Property
  weak var coordinator: HomeCoordinator?
  private let repository: any TodoItemRepository
  
  // MARK: - Model
  let collection: Results<TodoItem>
  var bindAction: ((Results<TodoItem>) -> Void)?
  var notificationToken: NotificationToken?
  
  // MARK: - Initializer
  init(coordinator: HomeCoordinator? = nil, repository: any TodoItemRepository) {
    self.coordinator = coordinator
    self.repository = repository
    self.collection = repository.fetch()
  }
  
  deinit {
    notificationToken?.invalidate()
  }
}

extension HomeViewModel {
  
  func filter(by state: TodoItem.State) -> Results<TodoItem> {
    switch state {
      case .today:
        let start = Calendar.current.startOfDay(for: .now)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        
        return collection
          .where(column: .dueDate, comparison: .greaterEqual, value: start as NSDate)
          .where(column: .dueDate, comparison: .less, value: end as NSDate)
        
      case .plan:
        return collection.where { !$0.isDone }
      
      case .all:
        return collection
      
      case .flag:
        return collection.where { $0.isFlag }
      
      case .done:
        return collection.where { $0.isDone }
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
