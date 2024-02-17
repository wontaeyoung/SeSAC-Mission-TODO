//
//  AddTodoViewModel.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/15/24.
//

import Foundation
import KazUtility
import RealmSwift

final class AddTodoViewModel: RealmObjectViewModel {
  
  typealias ObjectType = TodoItem
  
  // MARK: - Property
  weak var coordinator: AddTodoCoordinator?
  private let repository: TodoItemRepository
  
  // MARK: - Model
  var object: TodoItem
  var bindAction: ((TodoItem) -> Void)?
  var notificationToken: NotificationToken?
  
  // MARK: - Initializer
  init(coordinator: AddTodoCoordinator? = nil, repository: TodoItemRepository) {
    self.coordinator = coordinator
    self.repository = repository
    self.object = .empty
  }
  
  deinit {
    notificationToken?.invalidate()
  }
  
  // MARK: - Method
  func add() {
    do {
      try repository.create(with: object)
    } catch {
      let realmError: RealmError = .addFailed(error: error)
      LogManager.shared.log(with: realmError, to: .local)
      Task { await coordinator?.handle(error: realmError) }
    }
  }
}

extension AddTodoViewModel {
  
  func updateTitle(with title: String) {
    object.title = title
  }
  
  func updateMemo(with memo: String) {
    object.memo = memo
  }
  
  func updateDueDate(with date: Date) {
    object.dueDate = date
  }
}

extension AddTodoViewModel {
  
  @MainActor
  func dismiss() {
    coordinator?.dismiss()
  }
  
  @MainActor
  func showUpdateDueDateView(updateDateAction: @escaping (Date) -> Void) {
    coordinator?.showUpdateDueDateView(updateDateAction: updateDateAction)
  }
}
