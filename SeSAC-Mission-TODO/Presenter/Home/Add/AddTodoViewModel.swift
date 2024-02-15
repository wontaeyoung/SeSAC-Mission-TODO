//
//  AddTodoViewModel.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/15/24.
//

import KazUtility

final class AddTodoViewModel: ViewModel {
  
  weak var coordinator: HomeCoordinator?
  
  init(coordinator: HomeCoordinator? = nil) {
    self.coordinator = coordinator
  }
  
  let todoItem: Bindable<TodoItem> = .init(value: .empty)
  
  @MainActor
  func dismiss() {
    coordinator?.dismiss()
  }
}
