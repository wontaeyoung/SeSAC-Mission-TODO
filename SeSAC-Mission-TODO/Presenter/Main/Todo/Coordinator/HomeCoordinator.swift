//
//  HomeCoordinator.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/14/24.
//

import UIKit
import KazUtility
import RealmSwift

final class HomeCoordinator: Coordinator {
  
  weak var delegate: CoordinatorDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    showHomeView()
  }
}

extension HomeCoordinator {
  
  func showHomeView() {
    let todoBoxRepository = LiveTodoBoxRepository()
    let todoItemRepository = LiveTodoItemRepository()
    let viewModel = HomeViewModel(coordinator: self, todoBoxRepository: todoBoxRepository, todoItemRepository: todoItemRepository)
    let viewController = HomeViewController(viewModel: viewModel)
      .navigationTitle(with: "전체", displayMode: .always)
      .hideBackTitle()
    
    self.push(viewController)
  }
  
  func showMakeBoxView(makeBoxStyle: MakeBoxStyle, updating action: @escaping (TodoBox) -> Void) {
    let viewController = MakeBoxViewController(makeBoxStyle: makeBoxStyle, makeBoxAction: action)
      .navigationTitle(with: makeBoxStyle.title, displayMode: .never)
    
    self.push(viewController)
  }
  
  func showTodoListView(with collection: Results<TodoItem>, state: TodoItem.State) {
    let repository = LiveTodoItemRepository()
    let viewModel = TodoListViewModel(coordinator: self, repository: repository, collection: collection)
    let viewController = TodoListViewController(viewModel: viewModel)
      .navigationTitle(with: "\(state.title) 할 일", displayMode: .never)
    
    self.push(viewController)
  }
  
  func showDueDateFilterSheet(current date: Date, updating action: @escaping (Date) -> Void) {
    let viewController = DueDateFilterViewController(current: date, updating: action)
    
    self.present(viewController)
  }
  
  func combineMakeTodoFlow(makeTodoStyle: MakeTodoStyle) {
    let coordinator = MakeTodoCoordinator(self.navigationController)
    self.addChild(coordinator)
    
    coordinator.presentMakeTodoView(makeTodoStyle: makeTodoStyle)
  }
}
