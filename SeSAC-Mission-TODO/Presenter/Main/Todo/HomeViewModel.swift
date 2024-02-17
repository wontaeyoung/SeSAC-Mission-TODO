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
  
  func filter(by state: TodoItem.State) -> [TodoItem] {
    switch state {
      case .today:
        return collection.filter { $0.isToday }
      case .plan:
        return collection.filter { !$0.isDone }
      case .all:
        return collection.map { $0 }
      case .flag:
        return collection.filter { $0.isFlag }
      case .done:
        return collection.filter { $0.isDone }
    }
  }
  
  func filteredCount(by state: TodoItem.State) -> Int {
    return filter(by: state).count
  }
}

extension HomeViewModel {
  
  @MainActor
  func showAddTodoView() {
    coordinator?.showAddTodoView()
  }
}
