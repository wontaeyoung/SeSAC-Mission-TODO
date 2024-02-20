//
//  TodoListViewModel.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/16/24.
//

import Foundation
import KazUtility
import RealmSwift

final class TodoListViewModel: RealmCollectionViewmodel {
  
  typealias ObjectType = TodoItem
  
  // MARK: - Property
  weak var coordinator: HomeCoordinator?
  private let repository: any TodoItemRepository
  lazy var currentDueDate: Bindable<Date> = .init(value: .now).subscribed { date in
    self.filterCollectionByDueDate(current: date)
  }
  
  // MARK: - Model
  var collection: Results<TodoItem>
  var bindAction: ((Results<TodoItem>) -> Void)?
  var notificationToken: NotificationToken?
  
  // MARK: - Initializer
  init(coordinator: HomeCoordinator? = nil, repository: any TodoItemRepository, collection: Results<TodoItem>) {
    self.coordinator = coordinator
    self.repository = repository
    self.collection = collection
  }
  
  deinit {
    notificationToken?.invalidate()
  }
  
  // MARK: - Method
  func loadImage(router: PhotoFileRouter) -> Data? {
    guard router.fileExist else { return nil }
    
    return FileManager.default.contents(atPath: router.filePath)
  }
  
  func sortCollectionBy(_ selection: TodoSortSelection) {
    collection = collection.sorted(byKeyPath: selection.sortKey.name)
  }
  
  func filterCollectionByDueDate(current date: Date) {
    let (start, end) = DateManager.shared.getDateBetween(when: date)
    
    collection = collection
      .where(column: .dueDate, comparison: .greaterEqual, value: start as NSDate)
      .where(column: .dueDate, comparison: .less, value: end as NSDate)
  }
  
  func updateIsDone(with data: TodoItem) {
    do {
      try repository.update(to: data, with: [.isDone: !data.isDone])
    } catch {
      let error: RealmError = .updateFailed(error: error)
      LogManager.shared.log(with: error, to: .local)
      Task { await coordinator?.showErrorAlert(error: error) }
    }
  }
  
  func deleteItem(with data: TodoItem) {
    do {
      try repository.delete(with: data)
    } catch {
      let error: RealmError = .updateFailed(error: error)
      LogManager.shared.log(with: error, to: .local)
      Task { await coordinator?.showErrorAlert(error: error) }
    }
  }
}

@MainActor
extension TodoListViewModel {
  
  func showDueDateFilterSheet() {
    coordinator?.showDueDateFilterSheet(current: currentDueDate.current) { date in
      self.currentDueDate.set(date)
    }
  }
}
